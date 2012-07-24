require 'helper'
require 'redis'

class TestRedisAdapter < Test::Unit::TestCase
  context 'ConnectionHandling' do
    context 'redis_connection' do
      should 'create a new adapter' do
        Fabes::ConnectionAdapters::RedisAdapter.expects :new
        Fabes::ConnectionHandling.redis_connection({})
      end
    end
  end

  context 'ConnectionAdapters' do
    setup do
      @db = Redis.new
      @adapter = Fabes::ConnectionAdapters::RedisAdapter.new(@db)
      Fabes.stubs(:db).returns(@adapter)
      @experiment = Fabes::Experiment.new 'test', 'a', 'b', 'c'
      @adapter.save_experiment(@experiment)
    end

    should 'clear the db' do
      @db.set 'test', 'yay'
      @adapter.clear!
      assert_not_equal @db.get('test'), 'yay'
    end

    should 'save an experiment to the db' do
      assert_equal @db.scard('fabes:experiments'), 1
      assert @db.sismember 'fabes:experiments', 'test'
    end

    should 'save the alternatives to the db' do
      @experiment.alternatives.each do |alt|
        assert @db.exists "fabes:alternatives_pool:#{alt.id}"
        data = @db.hgetall "fabes:alternatives_pool:#{alt.id}"
        data.each do |field, value|
          assert_equal alt.send(field).to_s, value
        end
      end
    end

    should 'not find an inexistant experiment' do
      assert_nil @adapter.find_experiment('not_foundable')
    end

    should 'find an experiment' do
      found_experiment = @adapter.find_experiment('test')
      assert_not_nil found_experiment
      assert_equal found_experiment.name, @experiment.name
    end

    should 'find an experiment with the correct data' do
      found_experiment = @adapter.find_experiment('test')
      found_experiment.alternatives.each do |alt|
        %w(a b c).each do |expected_payload|
          expected_payload.include? alt.payload
        end
      end
    end

    should 'find an experiment with the correct control' do
      found_experiment = @adapter.find_experiment('test')
      assert_equal found_experiment.control.payload, 'a'
    end
  end
end
