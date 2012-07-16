require 'helper'

class TestExperiment < Test::Unit::TestCase

  context 'name' do
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
    should 'be able to select an alternative' do
      experiment = Fabes::Experiment.new 'test', 'yay'
      assert experiment.respond_to? :select_alternative!
    end

    should 'return an alternative' do
      experiment = Fabes::Experiment.new 'test', 'yay'
      alternative = experiment.select_alternative!
      assert_equal alternative.class, Fabes::Alternative
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
end
