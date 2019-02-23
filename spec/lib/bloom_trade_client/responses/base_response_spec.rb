require "spec_helper"

module BloomTradeClient
  RSpec.describe BaseResponse do

    describe "#errors" do
      let(:raw_response) do
        Typhoeus::Response.new(
          body: File.read(FIXTURES_DIR.join("errors.json"))
        )
      end
      let(:response) { described_class.new(raw_response: raw_response) }

      it "returns errors" do
        expect(response.errors[:description]).to eq "Hello"
        expect(response.errors[:metadata]).to eq({ max: "5.0" })
      end
    end

    describe "#parsed_body" do
      let(:raw_response) { Typhoeus::Response.new(body: {hi: "there"}.to_json) }
      let(:response) { described_class.new(raw_response: raw_response) }

      it "is the raw_response's body, parsed" do
        expect(response.parsed_body["hi"]).to eq "there"
        expect(response.parsed_body[:hi]).to eq "there"
      end
    end

  end
end
