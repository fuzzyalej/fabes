module Fabes
  class Experiment
    attr_accessor :name, :description, :alternatives

    def initialize(name, *alternatives)
      @name = name
      @alternatives = alternatives.map do |alternative|
        Fabes::Alternative.new alternative
      end
      save
    end

    def self.find_or_create(name, *alternatives)
      #TODO: What happens if same experiment but different alternatives?
      #TODO: check the validation of alternatives
      experiment = find(name) or new(name, *alternatives)
    end

    def self.find(name)
      Fabes.db.find_experiment name
    end

    def self.all
      Fabes.db.all_experiments
    end

    #TODO: make this an option and add different alternative selection algorithms
    def select_alternative!
      if exploration?
        random_alternative
      else #exploitation
        heaviest_alternative
      end
    end

    def find_alternative(id)
      @alternatives.select {|alternative| alternative.id == id }.first or control
    end

    def save
      Fabes.db.save_experiment(self)
    end

    def add_alternative(alternative)
      @alternatives.push alternative
    end

    def control
      @alternatives.first
    end

    private

    def exploration?
      rand() < 0.2 # 20% of times
    end

    def random_alternative
      @alternatives.shuffle.first
    end

    def heaviest_alternative
      @alternatives.max {|alternative| alternative.weight}
    end
  end
end
