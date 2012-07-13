require 'helper'

class TestAbstractAdapter < Test::Unit::TestCase
  context 'establish_connection' do
    should 'raise if no suitable adapter' do
      db = {adapter: 'crap'}
      assert_raise RuntimeError do
        Fabes::ConnectionHandling.establish_connection(db)
      end
    end

    should 'work if suitable adapter' do
      db = {adapter: 'redis'}
      Fabes::ConnectionHandling.expects :redis_connection
      Fabes::ConnectionHandling.establish_connection(db)
    end
  end
end
