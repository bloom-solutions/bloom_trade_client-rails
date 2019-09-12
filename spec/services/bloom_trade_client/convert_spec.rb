require "spec_helper"

module BloomTradeClient
  describe Convert do

    describe ".call" do
      context "base and counter_currency are the same" do
        let(:request) do
          build(:bloom_trade_client_convert_request, {
            base_currency: "USD",
            counter_currency: "USD",
          })
        end

        it "returns 1.0" do
          result = described_class.(request)
          expect(result.rate).to eq 1.0
          expect(result.state).to eq "valid"
          expect(result.expires_at).to be_nil
        end
      end

      context "direct_rate exists" do
        let(:request) do
          build(:bloom_trade_client_convert_request, {
            base_currency: "PHP",
            counter_currency: "USD",
            jwt: nil,
          })
        end

        before do
          Timecop.freeze
          create(:bloom_trade_client_exchange_rate, {
            base_currency: "PHP",
            counter_currency: "USD",
            mid: 50.0,
            expires_at: expires_at.to_i,
          })
        end
        after { Timecop.return }

        context "not expired" do
          let(:expires_at) { 5.minutes.from_now }
          it "calculates using the direct rate" do
            result = described_class.(request)
            expect(result.rate).to eq 50.0
            expect(result.state).to eq "valid"
            expect(result.expires_at).to eq 5.minutes.from_now.change(usec: 0)
              .to_datetime
          end
        end

        context "expired" do
          let(:expires_at) { 2.days.ago }

          it "still returns the direct rate but marked as expired" do
            result = described_class.(request)
            expect(result.rate).to eq 50.0
            expect(result.state).to eq "valid"
            expect(result).to be_expired
            expect(result.expires_at).to eq 2.days.ago.change(usec: 0)
              .to_datetime
          end
        end
      end

      context "reversed_rate exists" do
        let(:request) do
          build(:bloom_trade_client_convert_request, {
            base_currency: "USD",
            counter_currency: "PHP",
            jwt: nil,
          })
        end

        before do
          Timecop.freeze
          create(:bloom_trade_client_exchange_rate, {
            base_currency: "PHP",
            counter_currency: "USD",
            mid: 50.0,
            expires_at: expires_at.to_i,
          })
        end
        after { Timecop.return }

        context "not expired" do
          let(:expires_at) { 5.minutes.from_now }

          it "calculates by dividing with 1" do
            result = described_class.(request)
            expect(result).to be_a ConvertResult
            expect(result.rate).to eq 1 / 50.0
            expect(result).to be_valid
            expect(result.expires_at).to eq 5.minutes.from_now.change(usec: 0)
              .to_datetime
          end
        end

        context "expired" do
          let(:expires_at) { 2.days.ago }

          it "returns the rate divided by 1 and marked as expired" do
            result = described_class.(request)
            expect(result).to be_a ConvertResult
            expect(result).to be_expired
            expect(result.rate).to eq 1 / 50.0
            expect(result.expires_at).to eq 2.days.ago.change(usec: 0)
              .to_datetime
          end
        end
      end

      context "currency_pair don't exist, use reserve_currency" do
        let(:request) do
          build(:bloom_trade_client_convert_request, {
            base_currency: "BTC",
            counter_currency: "KRW",
            reserve_currency: "PHP",
            jwt: nil,
          })
        end

        before do
          Timecop.freeze
          create(:bloom_trade_client_exchange_rate, {
            base_currency: "PHP",
            counter_currency: "BTC",
            mid: 0.00001,
            expires_at: 5.minutes.from_now.to_i,
          })
        end
        after { Timecop.return }

        context "not expired" do
          before do
            create(:bloom_trade_client_exchange_rate, {
              base_currency: "PHP",
              counter_currency: "KRW",
              mid: 20,
              expires_at: 60.minutes.from_now.to_i,
            })
          end

          it "calculates by using the reserve currency" do
            result = described_class.(request)
            expect(result.rate).to eq 2_000_000
            expect(result).not_to be_expired
            expect(result).to be_valid
          end

          it "returns an expires_at with the earliest expiring currency pair" do
            result = described_class.(request)
            expect(result.expires_at)
              .to eq 5.minutes.from_now.change(usec: 0).to_datetime
            expect(result).not_to be_expired
            expect(result).to be_valid
          end
        end

        context "expired" do
          before do
            create(:bloom_trade_client_exchange_rate, {
              base_currency: "PHP",
              counter_currency: "KRW",
              mid: 20,
              expires_at: 60.minutes.ago.to_i,
            })
          end

          it "returns an expires_at with the earliest expiring currency pair" do
            result = described_class.(request)
            expect(result.expires_at)
              .to eq 60.minutes.ago.change(usec: 0).to_datetime
            expect(result).to be_expired
            expect(result).to be_valid
          end
        end
      end

      context "currency pair don't exist, unable to use reserve_currency" do
        it "returns 0.0" do
          create(:bloom_trade_client_exchange_rate, {
            base_currency: "PHP",
            counter_currency: "BTC",
            mid: 0.00001,
          })
          create(:bloom_trade_client_exchange_rate, {
            base_currency: "PHP",
            counter_currency: "KRW",
            mid: 20,
          })

          resulting_rate = described_class.(
            base_currency: "BTC",
            counter_currency: "AED",
            jwt: nil
          )
          expect(resulting_rate.rate).to eq 0.0
        end
      end

      context "returns specific rate types" do
        before do
          create(:bloom_trade_client_exchange_rate, {
            base_currency: "BTC",
            counter_currency: "USD",
            buy: 5000,
            mid: 6000,
            sell: 7000,
          })

          create(:bloom_trade_client_exchange_rate, {
            base_currency: "USD",
            counter_currency: "PHP",
            buy: 30,
            mid: 40,
            sell: 50,
          })

          BloomTradeClient.configure do |c|
            c.reserve_currency = "USD"
          end
        end

        after do
          BloomTradeClient.configure do |c|
            c.reserve_currency = "PHP"
          end
        end

        {
          buy: 5000 * 30,
          mid: 6000 * 40,
          sell: 7000 * 50,
        }.each do |rate_type, rate|
          context "#{rate_type} rates" do
            it "returns #{rate_type} rate" do
              resulting_rate = described_class.(
                base_currency: "BTC",
                counter_currency: "PHP",
                type: rate_type.to_s,
                jwt: nil
              )

              expect(resulting_rate.rate).to eq rate
            end
          end
        end
      end

      it "returns the rate with expiration time" do
        create(:bloom_trade_client_exchange_rate, {
          base_currency: "PHP",
          counter_currency: "USD",
          mid: 50.0,
          expires_at: 3.days.from_now
        })

        resulting_rate = described_class.(
          base_currency: "PHP",
          counter_currency: "USD",
          jwt: nil
        )

        expect(resulting_rate).to be_a ConvertResult
        expect(resulting_rate.rate).to eq 50.0
        expect(resulting_rate.expires_at).to_not be_nil
      end

      describe "converting with a given jwt" do
        let(:jwt_hash) { Digest::SHA256.base64digest("my-jwt") }

        context "direct_rate exists" do
          it "calculates using the direct rate" do
            create(:bloom_trade_client_exchange_rate, {
              base_currency: "PHP",
              counter_currency: "USD",
              mid: 50.0,
              jwt_hash: nil,
            })
            create(:bloom_trade_client_exchange_rate, {
              base_currency: "PHP",
              counter_currency: "USD",
              mid: 80.0,
              jwt_hash: jwt_hash,
            })

            resulting_rate = described_class.(
              base_currency: "PHP",
              counter_currency: "USD",
              jwt: "my-jwt",
            )
            expect(resulting_rate.rate).to eq 80.0
          end
        end

        context "reverse_rate exists" do
          it "calculates using the reverse rate" do
            create(:bloom_trade_client_exchange_rate, {
              base_currency: "PHP",
              counter_currency: "USD",
              mid: 50.0,
              jwt_hash: nil,
            })
            create(:bloom_trade_client_exchange_rate, {
              base_currency: "PHP",
              counter_currency: "USD",
              mid: 80.0,
              jwt_hash: jwt_hash,
            })

            resulting_rate = described_class.(
              base_currency: "USD",
              counter_currency: "PHP",
              jwt: "my-jwt",
            )
            expect(resulting_rate.rate).to eq (1/80.0)
          end
        end
      end
    end

  end
end
