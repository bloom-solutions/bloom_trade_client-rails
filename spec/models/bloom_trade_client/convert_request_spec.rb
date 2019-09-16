module BloomTradeClient
  RSpec.describe ConvertRequest, type: :virtus do

    it { is_expected.to have_attribute(:base_currency, String) }
    it { is_expected.to have_attribute(:counter_currency, String) }
    it { is_expected.to have_attribute(:request_type, String) }
    it { is_expected.to have_attribute(:reserve_currency, String) }
    it { is_expected.to have_attribute(:jwt, String) }

    describe "#validate" do
      it "raises an ArgumentError on invalid request type" do
        expect {
          described_class.new(request_type: "foo").validate
        }.to raise_error(
          ArgumentError,
          "invalid request_type 'foo'. Valid request_types buy, mid, sell",
        )
      end
    end

  end
end
