require "spec_helper"

module BloomTradeClient
  RSpec.describe ExchangeRate do

    describe "#expired?" do
      it "returns true if expires_at is nil" do
        model = described_class.new(expires_at: nil)
        expect(model).to be_expired
      end

      it "returns true if expires_at is past the current time" do
        model = described_class.new(expires_at: 3.days.ago)
        expect(model).to be_expired
      end

      it "returns false otherwise" do
        model = described_class.new(expires_at: 3.days.from_now)
        expect(model).not_to be_expired
      end
    end

  end
end
