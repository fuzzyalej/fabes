require 'helper'

class TestAlternative < Test::Unit::TestCase
  should 'have a weight' do
    alternative = Fabes::Alternative.new 1, 'abc'
    assert_not_nil alternative.weight
    assert_equal alternative.weight, 1
  end

  should 'have a payload' do
    alternative = Fabes::Alternative.new 1, 'abc'
    assert_not_nil alternative.payload
    assert_equal alternative.payload, 'abc'
  end

  should 'have participants' do
    alternative = Fabes::Alternative.new 1, 'abc'
    assert_not_nil alternative.participants
    assert_equal alternative.participants, 0
  end

  should 'have hits' do
    alternative = Fabes::Alternative.new 1, 'abc'
    assert_not_nil alternative.hits
    assert_equal alternative.hits, 0
  end

  should 'be able to increment its participants' do
    alternative = Fabes::Alternative.new 1, 'abc'

    assert_equal alternative.participants, 0
    alternative.increment_participants!
    assert_equal alternative.participants, 1
  end

  should 'be able to increment its hits' do
    alternative = Fabes::Alternative.new 1, 'abc'

    assert_equal alternative.hits, 0
    alternative.increment_hits!
    assert_equal alternative.hits, 1
  end
end
