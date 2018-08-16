require 'spec_helper'

module BloomTradeClient
  module ExchangeRates
    module Conversion
      RSpec.describe Buy do
        context 'rates exist' do
          let!(:existing_rate) do
            create(
              :bloom_trade_client_exchange_rate,
              base_currency: 'USD',
              counter_currency: 'PHP',
              buy: 30, mid: 40, sell: 50
            )
          end

          it 'same currency: 1' do
            direct_rate = described_class.('PHP', 'PHP')

            expect(direct_rate).to eq(1.0)
          end

          it 'if direct rate is found, use the buy rate' do
            direct_rate = described_class.('USD', 'PHP')

            expect(direct_rate).to eq(30.0)
          end

          it 'if the reverse rate is found, use the sell rate' do
            direct_rate = described_class.('PHP', 'USD')

            expect(direct_rate).to eq(1/50.to_f)
          end
        end

        context 'doesnt exist' do
          it 'return nil' do
            direct_rate = described_class.('IRRE', 'LEVANT')

            expect(direct_rate).to be_nil
          end
        end
      end
    end
  end
end
