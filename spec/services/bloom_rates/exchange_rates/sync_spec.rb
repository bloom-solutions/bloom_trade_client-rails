require "spec_helper"

module BloomRates
  module ExchangeRates
    describe Sync do
      let(:data_1) do
        {
          "base_currency" => "BTC",
          "counter_currency" => "USD",
          "buy" => "7900",
          "mid" => "8000",
          "sell" => "8100",
          "timestamp" => Time.current.to_i,
        }
      end
      let(:data_2) do
        {
          "base_currency" => "AUD",
          "counter_currency" => "USD",
          "buy" => "0.79",
          "mid" => "0.79",
          "sell" => "0.79",
          "timestamp" => Time.current.to_i,
        }
      end
      let(:data_3) do
        {
          "base_currency" => "USD",
          "counter_currency" => "PHP",
          "buy" => "52",
          "mid" => "52",
          "sell" => "52",
          "timestamp" => Time.current.to_i,
        }
      end

      it "receives a payload and saves or updates the Exchange Rate" do
        [data_1, data_2, data_3].each do |data|
          described_class.(data, nil)
        end

        expect_created_rates = BloomRates::ExchangeRate.all
        expect(expect_created_rates.count).to eq 3

        btcusd = BloomRates::ExchangeRate.find_by(
          base_currency: "BTC",
          counter_currency: "USD",
        )

        expect(btcusd).to be_present
        expect(btcusd.buy).to eq 7900
        expect(btcusd.sell).to eq 8100
        expect(btcusd.mid).to eq 8000

        audusd = BloomRates::ExchangeRate.find_by(
          base_currency: "AUD",
          counter_currency: "USD",
        )

        expect(audusd).to be_present
        expect(audusd.buy).to eq 0.79
        expect(audusd.sell).to eq 0.79
        expect(audusd.mid).to eq 0.79

        usdphp = BloomRates::ExchangeRate.find_by(
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
          [data_1, data_2, data_3].each do |data|
            described_class.(data, nil)
          end

          expect_created_rates = BloomRates::ExchangeRate.all
          expect(expect_created_rates.count).to eq 3

          btcusd = BloomRates::ExchangeRate.find_by(
            base_currency: "BTC",
            counter_currency: "USD",
          )

          expect(btcusd).to be_present
          expect(btcusd.buy).to eq 7900
          expect(btcusd.mid).to eq 8000
          expect(btcusd.sell).to eq 8100
        end
      end

    end
  end
end
