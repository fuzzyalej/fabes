module Fabes
  module ConnectionHandling
    def self.redis_connection(db)
      require 'redis'
      ConnectionAdapters::RedisAdapter.new(db)
    end
  end

  module ConnectionAdapters
    class RedisAdapter < AbstractAdapter
      def initialize(db)
        puts 'Initialized redis adapter'
        puts "#{db}"
      end
    end
  end
end
