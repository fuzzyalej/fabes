require 'helper'

class TestAbstractAdapter < Test::Unit::TestCase
  context 'establish_connection' do
    should 'raise if no suitable adapter' do
      assert_raise RuntimeError do
        db = 'http://uno:dos@tres.com:123/'
        Fabes::ConnectionHandling.establish_connection(db)
      end
    end

    should 'work if suitable adapter (redis)' do
      db = 'redis://uno:dos@tres.com:123/'
      Fabes::ConnectionHandling.expects :redis_connection
      Fabes::ConnectionHandling.establish_connection(db)
    end
  end
end
