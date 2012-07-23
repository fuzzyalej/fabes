module Fabes
  module Helper
    def fabes(name, control, *alternatives)
      experiment = Fabes::Experiment.find_or_create(name, *([control] + alternatives))
      if trackable_for experiment.name
        alternative = experiment.select_alternative!
        set_cookie_for experiment, alternative
        alternative.increment_participants!
        alternative.update_weight
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
      if scorable? experiment.name
        alternative.increment_hits!
        alternative.update_weight
        mark_as_scored experiment.name
      end
    rescue
      #Failed scoring, do nothin'
      nil
    end

    private

    def tracking
      session[:fabes] ||= {}
    end

    def set_cookie_for(experiment, alternative)
      tracking[experiment.name] = alternative.id
    end

    def current_alternative_for(experiment)
      id = tracking[experiment.name]
      experiment.find_alternative id
    end

    def trackable_for(name)
      !has_cookie_for(name) && !marked_as_scored?(name)
    end

    def has_cookie_for(name)
      !tracking[name].nil?
    end

    def scorable?(name)
      has_cookie_for(name) && !marked_as_scored?(name)
    end

    def marked_as_scored?(name)
      tracking[name] == :done
    end

    def mark_as_scored(name)
      tracking[name] = :done
    end
  end
end
