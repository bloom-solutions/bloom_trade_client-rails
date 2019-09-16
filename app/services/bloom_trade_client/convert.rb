module BloomTradeClient
  module Convert

    def self.call(request)
      result = ConvertResults::BuildFromDirectCurrencies.(request)
      return result if result.present?

      result = ConvertResults::BuildFromDirectRates.(request)
      return result if result.present?

      result = ConvertResults::BuildFromReserveRates.(request)
      return result if result.present?

      ConvertResults::BuildInvalid.(request)
    end

  end
end
