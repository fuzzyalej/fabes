require 'helper'

class TestAbstractAdapter < Test::Unit::TestCase
  context 'establish_connection' do
    should 'raise if no suitable adapter' do
      assert_raise RuntimeError do
        adapter = 'caca'
        db = ''
        Fabes::ConnectionHandling.establish_connection(db, adapter)
      end
    end

    should 'work if suitable adapter (redis)' do
      adapter = 'redis'
      db = ''
      Fabes::ConnectionHandling.expects :redis_connection
      Fabes::ConnectionHandling.establish_connection(db, adapter)
    end
  end
end
