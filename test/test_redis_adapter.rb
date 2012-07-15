require 'helper'
require 'redis'

class TestRedisAdapter < Test::Unit::TestCase
  context 'ConnectionHandling' do
    should 'create a new adapter' do
      Fabes::ConnectionAdapters::RedisAdapter.expects :new
      Fabes::ConnectionHandling.redis_connection({})
    end
  end

  context 'ConnectionAdapters' do
    setup do
      db = {}
      @adapter = Fabes::ConnectionAdapters::RedisAdapter.new(db)
      @adapter.clear!
      @experiment = Fabes::Experiment.new 'test', 'a', 'b', 'c'
      @adapter.save_experiment(@experiment)
      @redis = Redis.new
    end
    
    should 'save an experiment to the db' do
      assert_equal @redis.scard('fabes:experiments'), 1
      assert @redis.sismember 'fabes:experiments', 'test'
    end

    should 'save the alternatives to the db' do
      @experiment.alternatives.each do |alt|
        assert @redis.exists "fabes:alternatives:test:#{alt.id}"
        data = @redis.hgetall "fabes:alternatives:test:#{alt.id}"
        data.each do |field, value|
          assert_equal alt.send(field).to_s, value
        end
      end
    end
  end
end
