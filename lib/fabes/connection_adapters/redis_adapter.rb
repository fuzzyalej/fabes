module Fabes
  module ConnectionHandling
    def self.redis_connection(db)
      require 'redis'
      ConnectionAdapters::RedisAdapter.new(db)
    end
  end

  module ConnectionAdapters
    class RedisAdapter < AbstractAdapter
      NAMESPACE = 'fabes'
      def initialize(db)
        #TODO: Link here with a predefined redis and/or env variables
        @redis = ::Redis.new(db)
      end

      def clear!
        @redis.flushdb
      end

      def save_experiment(experiment)
        add_to_current_experiments(experiment.name)
        save_experiment_data(experiment)
      rescue
        raise "Unable to save experiment"
      end

      private

      def add_to_current_experiments(name)
        @redis.sadd "#{NAMESPACE}:experiments", name
      end

      def save_experiment_data(experiment)
        save_alternatives(experiment.name, experiment.alternatives)
      end

      def save_alternatives(base, alternatives)
        alternatives.each do |alt|
          data = Array.new
          alt.instance_variables.each do |var|
            data << var.slice(1..-1) << alt.instance_variable_get(var)
          end
          @redis.hmset "#{NAMESPACE}:alternatives:#{base}:#{alt.id}", *data
        end
      end
    end
  end
end
