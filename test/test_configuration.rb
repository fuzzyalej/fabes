require 'helper'

class TestConfiguration < Test::Unit::TestCase
  context 'initialization' do
    should 'have a database' do
      configuration = Fabes::Configuration.new
      assert configuration.respond_to? :database
    end
  end

  context 'dsl' do
    should 'have a use command' do
      configuration = Fabes::Configuration.new
      assert configuration.respond_to? :use
    end

    should 'set the database' do
      configuration = Fabes.configure do |c|
        c.use database: 'redis://user:pwd@host.com:123/'
      end
      assert_not_nil configuration.instance_variable_get :@database
    end

    should 'nilify the db with bad configuration' do
      configuration = Fabes.configure do |c|
        c.use fail: 'redis://user:pwd@host.com:123/'
      end
      assert_nil configuration.instance_variable_get :@database
    end
  end
end
