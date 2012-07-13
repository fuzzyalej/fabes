require 'helper'

class TestHelper < Test::Unit::TestCase
  include  Fabes::Helper

  should 'be able to start an experiment' do
    assert self.respond_to? :fabes
  end

  should 'be able to finish an experiment' do
    assert self.respond_to? :score!
  end

  #fabes
  should 'return a valid alternative' do
    alternative = fabes 'test experiment', 1, 2, 3
    assert_not_nil alternative
    assert_equal alternative.class, Fixnum
  end

  #score!
  #should 'increment hits' do
  #  fabes 'test', 1, 2
  #  score! 'test'
  #end

end
