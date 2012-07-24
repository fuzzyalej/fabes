module Fabes
  class Configuration
    attr_accessor :database

    def initialize
      @database = ENV['FABES_DB_URL'] || ENV['REDISTOGO_URL']
    end

    def use(options)
      @database = options[:database] || options [:db]
    rescue
      @database = nil
    end
  end
end
