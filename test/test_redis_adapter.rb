require 'helper'

class TestRedisAdapter < Test::Unit::TestCase
  context 'ConnectionHandling' do
    should 'create a new adapter' do
      Fabes::ConnectionAdapters::RedisAdapter.expects :new
      Fabes::ConnectionHandling.redis_connection({})
    end
  end
end
