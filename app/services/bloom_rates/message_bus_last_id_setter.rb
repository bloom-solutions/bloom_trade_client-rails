module BloomRates
  class MessageBusLastIdSetter
    def self.call
      return 0 if BloomRates::MessageBusLastId.count.zero?
      BloomRates::MessageBusLastId.order(created_at: :asc).last.last_id
    end
  end
end
