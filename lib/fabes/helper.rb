module Fabes
  module Helper
    def fabes(name, control, *alternatives)
      experiment = Fabes::Experiment.find_or_create(name, *([control] + alternatives))
      alternative = experiment.select_alternative!
      tracking[experiment.name] = alternative.id
      alternative.increment_participants!

      alternative.payload
    rescue
      control
    end

    def score!(name)
      experiment = Fabes::Experiment.find name
      alternative = current_alternative_for experiment
      alternative.increment_hits!
    end

    private

    def tracking
      session[:fabes] ||= {}
    end

    def current_alternative_for(experiment)
       id = tracking[experiment.name]
       experiment.find_alternative id
    end
  end
end

