require 'helper'

class TestHelper < Test::Unit::TestCase
  include  Fabes::Helper

  context 'fabes' do
    should 'be able to start an experiment' do
      assert self.respond_to? :fabes
    end

    should 'return a valid alternative' do
      alternative = fabes 'test experiment', 1, 2, 3
      assert_not_nil alternative
      assert %w(1 2 3).include?(alternative.to_s)
    end

    should 'return control when error' do
      Fabes::Experiment.expects(:find_or_create).then.raises(StandardError)
      alternative = fabes 'test experiment', 1, 2, 3
      assert_not_nil alternative
      assert_equal alternative, 1
    end
  end

  context 'score' do
    should 'be able to finish an experiment' do
      assert self.respond_to? :score!
    end

    should 'increment hits for an experiment' do
      experiment = Fabes::Experiment.new('test', 1, 2, 3)
      Fabes::Experiment.stubs(:find).returns(experiment)
      Fabes::Alternative.any_instance.expects :increment_hits!

      score! 'test'
    end
  end
end
