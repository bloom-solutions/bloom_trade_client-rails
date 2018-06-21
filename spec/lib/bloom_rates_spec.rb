require "spec_helper"

module BloomRates
  describe "configuration defaults" do
    it "has a default publisher_url" do
      expect(BloomRates.configuration.publisher_url).to eq "https://trade.bloom.solutions"
    end

    it "has a default reserve_currency" do
      expect(BloomRates.configuration.reserve_currency).to eq "PHP"
    end
  end

  describe ".setup" do
    let(:client) { double(MessageBus::Client) }

    it "calls MessageBus.subscribe" do
      expect(MessageBus::Client).to receive(:new).with(
        "https://trade.bloom.solutions"
      ).and_return(client)

      expect(client).to receive(:subscribe)
      expect(client).to receive(:start)

      BloomRates.setup
    end
  end
end
