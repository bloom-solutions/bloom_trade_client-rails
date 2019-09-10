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

  end
end
