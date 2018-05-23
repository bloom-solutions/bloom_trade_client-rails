require "spec_helper"

module BloomRates
  describe ".setup" do
    let(:client) { double(MessageBus::Client) }

    it "calls MessageBus.subscribe" do
      expect(MessageBus::Client).to receive(:new).with(
        "https://trade.bloom.solutions"
      ).and_return(client)

      expect(client).to receive(:subscribe).with("/exchange_rates")
      expect(client).to receive(:start)

      BloomRates.setup(channel: "/exchange_rates")
    end
  end
end
