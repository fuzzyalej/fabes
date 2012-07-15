module Fabes
  module ConnectionHandling
    def self.establish_connection(db)
      #https://github.com/rails/rails/blob/master/activerecord/lib/active_record/connection_handling.rb
      #https://github.com/assaf/vanity/blob/master/lib/vanity/adapters/abstract_adapter.rb
      #TODO: automagically parse db a la rails
      adapter_method = "#{db[:adapter]}_connection"
      send adapter_method, db
    rescue => e
      raise "Could not find #{db[:adapter]} adapter!"
    end
  end

  module ConnectionAdapters
    class AbstractAdapter
      def clear!;end
      def save_experiment(experiment);end
      def find_experiment(name);end
    end
  end
end
