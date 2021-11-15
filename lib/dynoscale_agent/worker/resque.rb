require 'singleton'

module DynoscaleAgent
  module Worker
    class Resque
      include Singleton

      def self.enabled?
        require 'resque'
        require 'resque_latency'
        true
      rescue LoadError
        false
      end

      def self.queue_latencies
        queues.map do |queue|
          [queue.name, (::Resque.latency(queue)* 1000).ceil, ::Resque.size(queue)]
      	end
      end

      def self.queues(source = ::Resque.queues)
        @@queues ||= source
      end

      def self.name
         'resque'
      end
    end
  end
end

