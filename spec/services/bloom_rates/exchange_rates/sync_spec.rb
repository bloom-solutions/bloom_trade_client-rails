require "spec_helper"

module BloomRates
  module ExchangeRates
    describe Sync do
      let(:exchange_rates_payload) do
        [
          {
            base_currency: "BTC",
            counter_currency: "USD",
            buy: "7900",
            mid: "8000",
            sell: "8100",
            timestamp: Time.current.to_i,
          },
          {
            base_currency: "AUD",
            counter_currency: "USD",
            buy: "0.79",
            mid: "0.79",
            sell: "0.79",
            timestamp: Time.current.to_i,
          },
          {
            base_currency: "USD",
            counter_currency: "PHP",
            buy: "52",
            mid: "52",
            sell: "52",
            timestamp: Time.current.to_i,
          },
        ].to_json
      end

      it "receives a payload and saves or updates the Exchange Rate" do
        described_class.(exchange_rates_payload)

        expect_created_rates = ExchangeRate.all
        expect(expect_created_rates.count).to eq 3

        btcusd = ExchangeRate.find_by(
          base_currency: "BTC",
          counter_currency: "USD",
        )

        expect(btcusd).to be_present
        expect(btcusd.buy).to eq 7900
        expect(btcusd.sell).to eq 8100
        expect(btcusd.mid).to eq 8000

        audusd = ExchangeRate.find_by(
          base_currency: "AUD",
          counter_currency: "USD",
        )

        expect(audusd).to be_present
        expect(audusd.buy).to eq 0.79
        expect(audusd.sell).to eq 0.79
        expect(audusd.mid).to eq 0.79

        usdphp = ExchangeRate.find_by(
          base_currency: "USD",
          counter_currency: "PHP",
        )

        expect(usdphp).to be_present
        expect(usdphp.buy).to eq 52
        expect(usdphp.sell).to eq 52
        expect(usdphp.mid).to eq 52
      end

      context "the exchange rates currently exist" do
        before do
          create(:bloom_rates_exchange_rate, {
            base_currency: "BTC",
            counter_currency: "USD",
            buy: 7800,
            mid: 7900,
            sell: 8000,
          })
        end

        it "updates the old rate" do
          described_class.(exchange_rates_payload)

          expect_created_rates = ExchangeRate.all
          expect(expect_created_rates.count).to eq 3

          btcusd = ExchangeRate.find_by(
            base_currency: "BTC",
            counter_currency: "USD",
          )

          expect(btcusd).to be_present
          expect(btcusd.buy).to eq 7900
          expect(btcusd.mid).to eq 8000
          expect(btcusd.sell).to eq 8100
        end
      end

      context "the payload wasn't parsable" do
        it "expect a raised JSON::ParserError" do
          expect { described_class.("[asdf::{}]") }.to raise_error(
            JSON::ParserError,
          )
        end
      end
    end
  end
end
