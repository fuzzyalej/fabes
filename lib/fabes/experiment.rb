module Fabes
  class Experiment
    attr_accessor :name, :description

    def initialize(name, *alternatives)
      @name = name
      @alternatives = alternatives.each_with_index.map do |id, alternative|
        Fabes::Alternative.new id, alternative
      end
      save
    end

    def self.find_or_create(name, *alternatives)
      #TODO: check the validation of alternatives
      experiment = find(name) or new(name, alternatives)
    end

    def self.find(name)
      #TODO: connect to the db and return the fiven experiment
    end

    def select_alternative!
      #TODO: Make this a real alternative selector
      @alternatives.shuffle.first
    end

    def find_alternative(id)
      @alternatives.select {|alternative| alternative.id == id }.first or raise BadAlternative
    end

    def save
      #save to the db
      #Fabes.db.save
    end
  end

  class BadAlternative < StandardError;end
end
