module BloomRates
  class MessageBusLastId < ApplicationRecord
    def self.create_or_update(last_id:)
      if BloomRates::MessageBusLastId.count.zero?
        BloomRates::MessageBusLastId.create!(last_id: last_id)
      else
        record = BloomRates::MessageBusLastId.last
        record.update_attributes(last_id: last_id)
      end
    end
  end
end
