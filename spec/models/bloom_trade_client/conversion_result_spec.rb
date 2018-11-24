module BloomTradeClient
  RSpec.describe ConversionResult, type: :virtus do

    it { is_expected.to have_attribute(:rate, Float) }
    it { is_expected.to have_attribute(:expires_at, Integer).with_default(0) }

  end
end
