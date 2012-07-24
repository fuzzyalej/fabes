module Fabes
  class Configuration
    attr_accessor :database, :factor

    def initialize
      @database = ENV['FABES_DB_URL'] || ENV['REDISTOGO_URL']
      @factor = 0.1
    end

    def use(options)
      @database = options[:database] || options [:db]
    rescue
      @database = nil
    end

    def bandit_factor(percentage)
      @factor = percentage
    end
  end
end
