require 'helper'

class TestHelper < Test::Unit::TestCase
  include  Fabes::Helper

  should 'be able to start an experiment' do
    assert self.respond_to? :fabes
  end

  should 'be able to finish an experiment' do
    assert self.respond_to? :score!
  end

  should 'return a valid alternative' do
    alternative = fabes 'test experiment', 1, 2, 3
    assert_not_nil alternative
    assert %w(1 2 3).include?(alternative.to_s)
  end
end
