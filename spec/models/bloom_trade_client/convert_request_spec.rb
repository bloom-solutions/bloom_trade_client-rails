module BloomTradeClient
  RSpec.describe ConvertRequest, type: :virtus do

    it { is_expected.to have_attribute(:base_currency, String) }
    it { is_expected.to have_attribute(:counter_currency, String) }
    it { is_expected.to have_attribute(:request_type, String) }
    it { is_expected.to have_attribute(:reserve_currency, String) }
    it { is_expected.to have_attribute(:jwt, String) }

  end
end
