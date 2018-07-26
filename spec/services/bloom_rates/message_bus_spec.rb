require 'spec_helper'

module BloomRates
  RSpec.describe MessageBusLastId do
    context 'no messagebus last_id record yet' do
      it 'creates a new messagebus last id record' do
        last_id = 123
        record = described_class.create_or_update(last_id: last_id)
        expect(record.last_id).to eq 123
        expect(described_class.count).to eq 1
      end
    end

    context 'already has messagebu last_id record' do
      it 'updates the last last id record' do
        create(:bloom_rates_message_bus_last_id, last_id: 123)
        last_id = 124

        described_class.create_or_update(last_id: last_id)
        updated_record = described_class.find_by(last_id: last_id)

        expect(updated_record.last_id).to eq 124
        expect(described_class.count).to eq 1
      end
    end
  end
end
