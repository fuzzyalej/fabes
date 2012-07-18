module Fabes
  module ConnectionHandling
    def self.redis_connection(db)
      require 'redis'
      db ||= ::Redis.new
      ConnectionAdapters::RedisAdapter.new(db)
    end
  end

  module ConnectionAdapters
    class RedisAdapter < AbstractAdapter
      def initialize(redis)
        @redis = redis
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

      def find_experiment(name)
        if @redis.sismember "fabes:experiments", name
          load_experiment(name)
        else
          nil
        end
      end

      def increment_hits!(id)
        @redis.hincrby "fabes:alternatives_pool:#{id}", 'hits', 1
      end

      def increment_participants!(id)
        @redis.hincrby "fabes:alternatives_pool:#{id}", 'participants', 1
      end

      private

      def add_to_current_experiments(name)
        @redis.sadd "fabes:experiments", name
      end

      def save_experiment_data(experiment)
        save_alternatives(experiment.name, experiment.alternatives)
      end

      def save_alternatives(base, alternatives)
        alternatives.each do |alt|
          add_to_alternatives(base, alt.id)
          data = Array.new
          alt.instance_variables.each do |var|
            data << var.slice(1..-1) << alt.instance_variable_get(var)
          end
          @redis.hmset "fabes:alternatives_pool:#{alt.id}", *data
        end
      end

      def add_to_alternatives(base, alternative)
        @redis.rpush "fabes:alternatives:#{base}", alternative
      end

      def load_experiment(name)
        experiment = Experiment.new(name)
        alternatives = load_alternatives(name)
        alternatives.each do |alternative|
          experiment.add_alternative(alternative)
        end
        experiment
      end

      def load_alternatives(base)
        alternatives = Array.new
          ids = @redis.lrange "fabes:alternatives:#{base}", 0, -1
          ids.each do |id|
            alternatives.push load_alternative(id)
          end
        alternatives
      end

      def load_alternative(id)
        data = @redis.hgetall "fabes:alternatives_pool:#{id}"
        Alternative.create_from data
      end
    end
  end
end
