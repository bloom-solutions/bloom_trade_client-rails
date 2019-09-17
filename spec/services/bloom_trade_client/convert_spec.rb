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

        it "returns 1.0 and does not expire" do
          result = described_class.(request)
          expect(result.rate).to eq 1.0
          expect(result.state).to eq "valid"
          expect(result.expires_at).to be_nil
          expect(result).not_to be_nil
          expect(result).to be_success
          expect(result).to be_valid
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
            expect(result.rate_currency).to eq "KRW"
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
            expect(result).to be_success
            expect(result).to be_valid
          end
        end

        context "only 1 pair exists" do
          it "returns nil" do
            result = described_class.(request)
            expect(result.rate).to be_nil
            expect(result.expires_at).to be_nil
            expect(result).to be_invalid
            expect(result).not_to be_success
            expect(result.message).to eq "BTCKRW mid rate not available"
          end
        end
      end

      context "currency pair don't exist, unable to use reserve_currency" do
        let(:request) do
          build(:bloom_trade_client_convert_request, {
            base_currency: "BTC",
            counter_currency: "AED",
            jwt: nil,
          })
        end

        it "returns invalid" do
          result = described_class.(request)
          expect(result.rate).to be_nil
          expect(result.expires_at).to be_nil
          expect(result).to be_invalid
          expect(result).not_to be_success
          expect(result.message).to eq "BTCAED mid rate not available"
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
            let(:request) do
              build(:bloom_trade_client_convert_request, {
                base_currency: "BTC",
                counter_currency: "PHP",
                jwt: nil,
                request_type: rate_type.to_s,
              })
            end

            it "returns #{rate_type} rate" do
              result = described_class.(request)
              expect(result.rate).to eq rate
              expect(result.rate_currency).to eq "PHP"
            end
          end
        end
      end

      describe "converting with a given jwt" do
        let(:jwt_hash) { Digest::SHA256.base64digest("my-jwt") }
        let(:request) do
          build(:bloom_trade_client_convert_request, {
            base_currency: "PHP",
            counter_currency: "USD",
            jwt: "my-jwt",
          })
        end
        before do
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
        end

        context "direct_rate exists" do
          it "calculates using the direct rate" do
            expect(described_class.(request).rate).to eq 80.0
          end
        end

        context "reverse_rate exists" do
          let(:request) do
            build(:bloom_trade_client_convert_request, {
              base_currency: "USD",
              counter_currency: "PHP",
              jwt: "my-jwt",
            })
          end

          it "calculates using the reverse rate" do
            expect(described_class.(request).rate).to eq 1.0 / 80.0
          end
        end
      end
    end

  end
end
