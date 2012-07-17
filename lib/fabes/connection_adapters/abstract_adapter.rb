module Fabes
  module ConnectionHandling
    def self.establish_connection(db, adapter)
      #TODO: automagically parse db a la rails
      #REF: https://github.com/rails/rails/blob/master/activerecord/lib/active_record/connection_handling.rb

      adapter_method = "#{adapter}_connection"
      send adapter_method, db
    rescue => e
      raise "Could not find #{adapter} adapter!"
    end
  end

  module ConnectionAdapters
    class AbstractAdapter
      def clear!;end
      def save_experiment(experiment);end
      def find_experiment(name);end
      def increment_participants!(id);end
      def increment_hits!(id);end
    end
  end
end
