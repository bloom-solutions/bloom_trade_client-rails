require "spec_helper"

module BloomRates
  module ExchangeRates
    describe Convert do
      describe ".call" do
        context "base and counter_currency are the same" do
          it "returns 1.0" do
            resulting_rate = described_class.("PHP", "PHP")
            expect(resulting_rate).to eq 1.0
          end
        end

        context "direct_rate exists" do
          it "calculates using the direct rate" do
            create(:bloom_rates_exchange_rate, {
              base_currency: "PHP",
              counter_currency: "USD",
              mid: 50.0,
            })

            resulting_rate = described_class.("PHP", "USD")
            expect(resulting_rate).to eq 50.0
          end
        end

        context "reversed_rate exists" do
          it "calculates by dividing with 1" do
            create(:bloom_rates_exchange_rate, {
              base_currency: "PHP",
              counter_currency: "USD",
              mid: 50.0,
            })

            resulting_rate = described_class.("USD", "PHP")
            expect(resulting_rate).to eq 0.02
            expect(1.0 / resulting_rate).to eq 50.0
          end
        end

        context "currency_pair don't exist, use reserve_currency" do
          it "calculates by using the reserve currency" do
            create(:bloom_rates_exchange_rate, {
              base_currency: "PHP",
              counter_currency: "BTC",
              mid: 0.00001,
            })
            create(:bloom_rates_exchange_rate, {
              base_currency: "PHP",
              counter_currency: "KRW",
              mid: 20,
            })

            resulting_rate = described_class.("BTC", "KRW", "PHP")
            expect(resulting_rate).to eq 2_000_000
          end
        end

        context "currency_pair don't exist, use reserve_currency" do
          it "calculates by using the reserve currency" do
            create(:bloom_rates_exchange_rate, {
              base_currency: "PHP",
              counter_currency: "BTC",
              mid: 0.00001,
            })
            create(:bloom_rates_exchange_rate, {
              base_currency: "PHP",
              counter_currency: "KRW",
              mid: 20,
            })

            resulting_rate = described_class.("BTC", "KRW", "PHP")
            expect(resulting_rate).to eq 2_000_000
          end
        end

        context "currency pair don't exist, unable to use reserve_currency" do
          it "returns 0.0" do
            create(:bloom_rates_exchange_rate, {
              base_currency: "PHP",
              counter_currency: "BTC",
              mid: 0.00001,
            })
            create(:bloom_rates_exchange_rate, {
              base_currency: "PHP",
              counter_currency: "KRW",
              mid: 20,
            })

            resulting_rate = described_class.("BTC", "AED")
            expect(resulting_rate).to eq 0.0
          end
        end
      end

    end
  end
end
