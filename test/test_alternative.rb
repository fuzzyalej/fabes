require 'helper'

class TestAlternative < Test::Unit::TestCase
  context 'initialization' do
    should 'have an id' do
      alternative = Fabes::Alternative.new 'abc'
      assert_not_nil alternative.id
    end

    should 'have a weight' do
      alternative = Fabes::Alternative.new 'abc'
      assert_not_nil alternative.weight
      assert_equal alternative.weight, 1
    end

    should 'have a payload' do
      alternative = Fabes::Alternative.new 'abc'
      assert_not_nil alternative.payload
      assert_equal alternative.payload, 'abc'
    end

    should 'have participants' do
      alternative = Fabes::Alternative.new 'abc'
      assert_not_nil alternative.participants
      assert_equal alternative.participants, 0
    end

    should 'have hits' do
      alternative = Fabes::Alternative.new 'abc'
      assert_not_nil alternative.hits
      assert_equal alternative.hits, 0
    end
  end

  context 'increment_participants!' do
    should 'be able to increment its participants' do
      alternative = Fabes::Alternative.new 'abc'

      assert_equal alternative.participants, 0
      alternative.increment_participants!
      assert_equal alternative.participants, 1
    end
  end

  context 'increment_hits!' do
    should 'be able to increment its hits' do
      alternative = Fabes::Alternative.new 'abc'

      assert_equal alternative.hits, 0
      alternative.increment_hits!
      assert_equal alternative.hits, 1
    end
  end

  context 'create_from' do
    should 'create a new alternative from the required data' do
      hash = {payload: 1}
      alternative = Fabes::Alternative.create_from(hash)
      assert_not_nil alternative
      assert_equal alternative.class, Fabes::Alternative
    end

    should 'create the new alternative with the given data' do
      hash = {payload: 1, id: 'abc', weight: 0.5, participants: 9, hits: 2}
      alternative = Fabes::Alternative.create_from(hash)
      assert_equal alternative.payload, 1
      assert_equal alternative.id, 'abc'
      assert_equal alternative.weight, 0.5
      assert_equal alternative.participants, 9
      assert_equal alternative.hits, 2
    end

    should 'fail creating a new alternative if not enough data' do
      assert_raise RuntimeError do
        Fabes::Alternative.create_from(caca: 1)
      end
    end
  end
end
