require 'sinatra'

module Fabes
  class Admin < Sinatra::Base

    get '/' do
      @experiments = Fabes::Experiment.all
    end
  end
end
