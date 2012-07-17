require 'helper'

class TestConfiguration < Test::Unit::TestCase
  context 'initialization' do
    should 'have an adapter' do
      configuration = Fabes::Configuration.new
      assert configuration.respond_to? :adapter
    end
  end

  context 'dsl' do
    should 'have a use command' do
      configuration = Fabes::Configuration.new
      assert configuration.respond_to? :use
    end

    should 'set the adapter' do
      configuration = Fabes.configure do |c|
        c.use db: 'abc', adapter: :redis
      end
      assert_not_nil configuration.instance_variable_get :@adapter
      assert_equal configuration.instance_variable_get(:@adapter), 'redis'
    end

    should 'set the db' do
      configuration = Fabes.configure do |c|
        c.use db: 'abc', adapter: :redis
      end
      assert_not_nil configuration.instance_variable_get(:@db)
      assert_equal configuration.instance_variable_get(:@db), 'abc'
    end
  end
end
