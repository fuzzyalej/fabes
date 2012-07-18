require 'helper'

class TestHelper < Test::Unit::TestCase
  include  Fabes::Helper

  def tracking
    session[:fabes] ||= {}
  end

  context 'fabes' do
    should 'be able to start an experiment' do
      assert self.respond_to? :fabes
    end

    should 'return a valid alternative' do
      alternative = fabes 'test', 1, 2, 3
      assert_not_nil alternative
      assert %w(1 2 3).include?(alternative.to_s)
    end

    should 'return control when error' do
      Fabes::Experiment.expects(:find_or_create).then.raises(StandardError)
      alternative = fabes 'test', 1, 2, 3
      assert_not_nil alternative
      assert_equal alternative, 1
    end

    should 'memorize options' do
      alternative = fabes 'test', 'a', 'b', 'c'
      second_alternative = fabes 'test', 'a', 'b', 'c'
      assert_equal alternative, second_alternative
    end
  end

  context 'score' do
    should 'be able to finish an experiment' do
      assert self.respond_to? :score!
    end

    should 'increment hits for an experiment' do
      experiment = Fabes::Experiment.new('test', 1, 2, 3)
      tracking['test'] = experiment.alternatives.first.id
      Fabes::Experiment.stubs(:find).returns(experiment)
      Fabes::Alternative.any_instance.expects :increment_hits!
      score! 'test'
    end

    should 'not score twice the same person/experiment' do
      experiment = Fabes::Experiment.new('test', 1, 2, 3)
      tracking['test'] = experiment.alternatives.first.id
      Fabes::Experiment.stubs(:find).returns(experiment)
      Fabes::Alternative.any_instance.expects(:increment_hits!).once
      score! 'test'
      score! 'test'
    end

    should 'score two different experiments'
  end
end
