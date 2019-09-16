require "spec_helper"

module BloomTradeClient
  RSpec.describe ExchangeRate do

    describe "#expired?" do
      it "returns false if expires_at is nil" do
        model = described_class.new(expires_at: nil)
        expect(model).not_to be_expired
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

    describe ".resolve" do
      let(:resolution) do
        described_class.resolve(
          base_currency: "USD",
          counter_currency: "PHP",
          jwt: nil,
        )
      end

      context "direct rate" do
        before do
          create(:bloom_trade_client_exchange_rate, {
            base_currency: "USD",
            counter_currency: "PHP",
          })
        end

        it "returns direct orientation and rate" do
          expect(resolution[:rate].base_currency).to eq "USD"
          expect(resolution[:rate].counter_currency).to eq "PHP"
          expect(resolution[:orientation]).to eq "direct"
        end
      end

      context "reverse rate" do
        before do
          create(:bloom_trade_client_exchange_rate, {
            base_currency: "PHP",
            counter_currency: "USD",
          })
        end

        it "returns reverse orientation and rate" do
          expect(resolution[:rate].base_currency).to eq "PHP"
          expect(resolution[:rate].counter_currency).to eq "USD"
          expect(resolution[:orientation]).to eq "reversed"
        end
      end
    end

  end
end
