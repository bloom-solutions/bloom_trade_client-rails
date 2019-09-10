module BloomTradeClient
  RSpec.describe ConvertResult, type: :virtus do

    it { is_expected.to have_attribute(:rate, BigDecimal) }
    it { is_expected.to have_attribute(:state, String) }
    it { is_expected.to have_attribute(:expires_at, DateTime) }

  end
end
