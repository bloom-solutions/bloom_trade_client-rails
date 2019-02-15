require "spec_helper"

module BloomTradeClient
  module ExchangeRates
    describe Sync do
      let(:data_1) do
        {
          "base_currency" => "BTC",
          "counter_currency" => "USD",
          "buy" => "7900",
          "mid" => "8000",
          "sell" => "8100",
          "expires_at" => Time.current.to_i,
        }
      end
      let(:data_2) do
        {
          "base_currency" => "AUD",
          "counter_currency" => "USD",
          "buy" => "0.79",
          "mid" => "0.79",
          "sell" => "0.79",
          "expires_at" => Time.current.to_i,
        }
      end
      let(:data_3) do
        {
          "base_currency" => "USD",
          "counter_currency" => "PHP",
          "buy" => "52",
          "mid" => "52",
          "sell" => "52",
          "expires_at" => Time.current.to_i,
        }
      end
      let(:data_4) do
        {
          "base_currency" => "USD",
          "counter_currency" => "PHP",
          "buy" => "70",
          "mid" => "80",
          "sell" => "90",
          "expires_at" => Time.current.to_i,
        }
      end
      let(:token) { "jwt-token" }
      let(:headers) do
        { "Authorization" => "Bearer #{token}" }
      end

      it "receives a payload and saves or updates the Exchange Rate" do
        [data_1, data_2, data_3].each do |data|
          described_class.(data, nil, nil)
        end
        described_class.(data_4, nil, headers)

        expect_created_rates = BloomTradeClient::ExchangeRate.all
        expect(expect_created_rates.count).to eq 4

        btcusd = BloomTradeClient::ExchangeRate.find_by(
          base_currency: "BTC",
          counter_currency: "USD",
          jwt_hash: nil
        )

        expect(btcusd).to be_present
        expect(btcusd.buy).to eq 7900
        expect(btcusd.sell).to eq 8100
        expect(btcusd.mid).to eq 8000
        expect(btcusd.expires_at).to eq data_1['expires_at']

        audusd = BloomTradeClient::ExchangeRate.find_by(
          base_currency: "AUD",
          counter_currency: "USD",
          jwt_hash: nil
        )

        expect(audusd).to be_present
        expect(audusd.buy).to eq 0.79
        expect(audusd.sell).to eq 0.79
        expect(audusd.mid).to eq 0.79
        expect(audusd.expires_at).to eq data_2['expires_at']

        usdphp = BloomTradeClient::ExchangeRate.find_by(
          base_currency: "USD",
          counter_currency: "PHP",
          jwt_hash: nil
        )

        expect(usdphp).to be_present
        expect(usdphp.buy).to eq 52
        expect(usdphp.sell).to eq 52
        expect(usdphp.mid).to eq 52
        expect(usdphp.expires_at).to eq data_3['expires_at']
      end

      context "the global exchange rates currently exist" do
        before do
          create(:bloom_trade_client_exchange_rate, {
            base_currency: "BTC",
            counter_currency: "USD",
            buy: 7800,
            mid: 7900,
            sell: 8000,
            jwt_hash: nil,
          })
        end

        it "updates the old rate" do
          [data_1, data_2, data_3].each do |data|
            described_class.(data, nil, nil)
          end
          described_class.(data_4, nil, headers)

          expect_created_rates = BloomTradeClient::ExchangeRate.all
          expect(expect_created_rates.count).to eq 4

          btcusd = BloomTradeClient::ExchangeRate.find_by(
            base_currency: "BTC",
            counter_currency: "USD",
            jwt_hash: nil
          )

          expect(btcusd).to be_present
          expect(btcusd.buy).to eq 7900
          expect(btcusd.mid).to eq 8000
          expect(btcusd.sell).to eq 8100
          expect(btcusd.expires_at).to eq data_1['expires_at']
        end
      end

      context "the jwt-scoped exchange rate currently exist" do
        let(:jwt_hash) { Digest::SHA256.base64digest(token) }

        before do
          create(:bloom_trade_client_exchange_rate, {
            base_currency: "USD",
            counter_currency: "PHP",
            buy: "100",
            mid: "110",
            sell: "120",
            expires_at: Time.current.to_i,
            jwt_hash: jwt_hash,
          })
        end

        it "updates the old rate" do
          [data_1, data_2, data_3].each do |data|
            described_class.(data, nil, nil)
          end
          described_class.(data_4, nil, headers)

          expect_created_rates = BloomTradeClient::ExchangeRate.all
          expect(expect_created_rates.count).to eq 4

          btcusd = BloomTradeClient::ExchangeRate.find_by(
            base_currency: "USD",
            counter_currency: "PHP",
            jwt_hash: jwt_hash
          )

          expect(btcusd).to be_present
          expect(btcusd.buy).to eq 70
          expect(btcusd.mid).to eq 80
          expect(btcusd.sell).to eq 90
          expect(btcusd.expires_at).to eq data_4["expires_at"]
        end
      end

    end
  end
end
