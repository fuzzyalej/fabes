require 'helper'

class TestExperiment < Test::Unit::TestCase

  context 'initialization' do
    should "have a name" do
      experiment = Fabes::Experiment.new 'test', 'yay'
      assert experiment.respond_to? :name
    end

    should "set a name" do
      experiment = Fabes::Experiment.new 'test', 'yay'
      experiment.name = 'Test name'
      assert_equal experiment.name, 'Test name'
    end

    should "set a description" do
      experiment = Fabes::Experiment.new 'test', 'yay'
      experiment.description = 'yay'
      assert_equal experiment.description, 'yay'
    end

    should "raise error if no name given" do
      assert_raise ArgumentError do
        experiment = Fabes::Experiment.new
      end
    end

    should "be initialized with a name" do
      experiment = Fabes::Experiment.new 'test', 'yay'
      assert_not_nil experiment
      assert_equal experiment.name, 'test'
    end
  end

  context 'alternative' do
    setup do
      @experiment = Fabes::Experiment.new 'test', 'yay', 'yey'
    end

    should 'be able to select an alternative' do
      assert @experiment.respond_to? :select_alternative!
    end

    should 'return an alternative' do
      alternative = @experiment.select_alternative!
      assert_equal alternative.class, Fabes::Alternative
    end

    should 'return a valid alternative' do
      alternative = @experiment.select_alternative!
      assert alternative.payload.match /y?y/
    end

    should 'shuffle when exploration'

    should 'select the heaviest when exploitation' do
      @experiment.alternatives.first.weight = 0.1
      @experiment.stubs(:exploration?).returns(:false)
      alternative = @experiment.select_alternative!
      assert_not_equal alternative.id, @experiment.alternatives.first
    end
  end

  context 'save' do
    should 'save the experiment' do
      experiment = Fabes::Experiment.new 'test', 'yay'
      Fabes.stubs(db: mock(:save_experiment))

      experiment.save
    end
  end

  context 'find' do
    should 'find the given experiment' do
      Fabes::Experiment.new 'test', 'yay'
      experiment = Fabes::Experiment.find 'test'
      assert_not_nil experiment
      assert_equal experiment.name, 'test'
    end

    should 'return nil when experiment not found' do
      Fabes::Experiment.new 'test', 'yay'
      experiment = Fabes::Experiment.find 'not_found'
      assert_nil experiment
    end
  end

  context 'all' do
    setup do
      Fabes::Experiment.new 'test', 'a', 'b', 'c'
      Fabes::Experiment.new 'test2', 1, 2, 3
      @experiments = Fabes::Experiment.all
    end

    should 'find all experiments (class)' do
      @experiments.each do |exp|
        assert_equal exp.class, Fabes::Experiment
      end
    end

    should 'find all experiments (name)' do
      @experiments.map(&:name).each do |name|
        assert %w(test test2).include?(name)
      end
    end

    should 'find all experiments (count)' do
      assert_equal @experiments.count, 2
    end
  end
end
