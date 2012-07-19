require 'sinatra'

module Fabes
  class Admin < Sinatra::Base
    dir = File.dirname File.expand_path __FILE__
    set :views, dir + '/admin/views'
    set :public_folder, dir + '/admin/public'
    set :static, true

    get '/' do
      @experiments = Fabes::Experiment.all
      haml :index
    end
  end
end
