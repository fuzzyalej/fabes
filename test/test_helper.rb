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

    should 'increment the participant count if trackable' do
      self.expects(:trackable_for).returns(true)
      Fabes::Alternative.any_instance.expects :increment_participants!
      alternative = fabes 'test', 1, 2, 3
    end

    should 'not increment the participant count if already participated' do
      self.expects(:trackable_for).returns(false)
      Fabes::Alternative.any_instance.expects(:increment_participants!).times(0)
      alternative = fabes 'test', 1, 2, 3
    end
  end

  context 'score' do
    setup do
      @experiment = Fabes::Experiment.new('test', 1, 2, 3)
      @alternative = @experiment.alternatives.first
      tracking['test'] = @alternative.id
    end
    should 'be able to finish an experiment' do
      assert self.respond_to? :score!
    end

    should 'increment hits for an experiment' do
      Fabes::Alternative.any_instance.expects :increment_hits!
      score! 'test'
    end

    should 'not score twice the same person/experiment' do
      Fabes::Alternative.any_instance.expects(:increment_hits!).once
      score! 'test'
      score! 'test'
    end

    should 'not score if not a participant' do
      self.expects(:scorable?).returns(false)
      Fabes::Alternative.any_instance.expects(:increment_hits!).times(0)
      score! 'test'
    end

    should 'score two different experiments' do
      @experiment2 = Fabes::Experiment.new('test2', 4, 5, 6)
      tracking['test2'] = @experiment2.alternatives.first.id
      Fabes::Alternative.any_instance.expects(:increment_hits!).twice
      score! 'test'
      score! 'test2'
    end
  end
end
