module BloomTradeClient
  RSpec.describe ConvertResult, type: :virtus do

    it { is_expected.to have_attribute(:rate, BigDecimal) }
    it { is_expected.to have_attribute(:state, String) }
    it { is_expected.to have_attribute(:message, String) }
    it { is_expected.to have_attribute(:request, ConvertRequest) }
    it { is_expected.to have_attribute(:expires_at, DateTime) }

    described_class::STATES.keys.each do |state|
      describe "##{state.to_s}?" do

        subject do
          result = described_class.new(state: state.to_s)
          result.send("#{state.to_s}?".to_sym)
        end

        it { is_expected.to eq true }
      end
    end

    describe "#success?" do
      context "invalid?" do
        subject do
          described_class.new(state: described_class::STATES[:invalid])
        end
        it { is_expected.not_to be_success }
      end

      context "expired?" do
        subject { described_class.new(expires_at: 1.minute.ago) }
        it { is_expected.to be_success }
      end

      context "valid?" do
        subject { described_class.new(state: "valid") }
        it { is_expected.to be_success }
      end
    end

  end
end
