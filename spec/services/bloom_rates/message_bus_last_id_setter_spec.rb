require "spec_helper"

module BloomRates
  RSpec.describe MessageBusLastIdSetter do
    context "there is no message bus last id record yet" do
      it "returns 0" do
        last_id = described_class.()
        expect(last_id).to eq 0
      end
    end

    context "there is already a message bus last id record" do
      let!(:last_id_1) { create(:bloom_rates_message_bus_last_id, last_id: 12345) }
      let!(:last_id_2) { create(:bloom_rates_message_bus_last_id, last_id: 12346) }

      it "returns the latest transaction transaction id" do
        last_id = described_class.()
        expect(last_id).to eq 12346
      end
    end
  end
end
