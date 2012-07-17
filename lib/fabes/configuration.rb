module Fabes
  class Configuration
    attr_accessor :adapter, :db

    def initialize
      @adapter = 'redis'
      @db = nil
    end

    def use(db_config)
      @adapter = db_config[:adapter].to_s
      @db = db_config[:db] || ENV['FABES_DB_URL'] || ENV['REDISTOGO_URL']
    rescue => e
      raise "Bad 'use' config: #{e.message}"
    end
  end
end
