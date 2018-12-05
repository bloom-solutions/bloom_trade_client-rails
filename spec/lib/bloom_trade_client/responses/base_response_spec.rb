require "spec_helper"

module BloomTradeClient
  RSpec.describe BaseResponse do

    describe "#errors" do
      let(:response) do
        described_class.new(body: File.read(FIXTURES_DIR.join("errors.json")))
      end

      it "returns errors" do
        expect(response.errors[:description]).to eq "Hello"
        expect(response.errors[:metadata]).to eq({ max: "5.0" })
      end
    end

  end
end
