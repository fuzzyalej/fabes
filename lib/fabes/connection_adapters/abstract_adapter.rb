module Fabes
  module ConnectionHandling
    require 'ostruct'
    extend self

    def establish_connection(db)
      database = connection_url_to_hash(db)
      adapter = database.delete :adapter
      adapter_method = "#{adapter}_connection"
      send adapter_method, database
    rescue
      raise "Could not find #{adapter} adapter!"
    end

    #from https://github.com/rails/rails/blob/master/activerecord/lib/active_record/connection_adapters/connection_specification.rb#L65
    def connection_url_to_hash(url)
      url ||= ''
      uri = URI.parse url
      spec = {
        host:     uri.host,
        port:     uri.port,
        adapter:  uri.scheme,
        username: uri.user,
        password: uri.password,
        database: uri.path.sub(%r{^/}, '')
      }
      spec.reject! {|_, value| !value}
      {adapter: 'redis'}.merge spec
    end
  end

  module ConnectionAdapters
    class AbstractAdapter
      def clear!;end
      def save_experiment(experiment);end
      def find_experiment(name);end
      def increment_participants!(id);end
      def increment_hits!(id);end
      def update_weight(id, weight);end
      def all_experiments;end
    end
  end
end
