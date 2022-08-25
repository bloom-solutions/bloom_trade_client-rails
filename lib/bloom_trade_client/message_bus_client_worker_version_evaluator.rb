module BloomTradeClient
  class MessageBusClientWorkerVersionEvaluator

    def self.version_2_1_1_and_greater?
      version >= Gem::Version.new("2.1.1")
    end

    def self.version
      version = Gem::Version.new(MessageBusClientWorker::VERSION)
    end

  end
end
