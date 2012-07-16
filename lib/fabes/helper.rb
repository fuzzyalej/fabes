module Fabes
  module Helper
    def fabes(name, control, *alternatives)
      experiment = Fabes::Experiment.find_or_create(name, *([control] + alternatives))
      if trackable_for experiment.name
        alternative = experiment.select_alternative!
        tracking[experiment.name] = alternative.id
        alternative.increment_participants!
      else
        alternative = current_alternative_for experiment
      end

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

    def trackable_for(name)
      !has_cookie_for name
    end

    def has_cookie_for(name)
      !tracking[name].nil?
    end
  end
end

