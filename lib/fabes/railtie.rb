module Fabes
  class FabesRailtie < ::Rails::Railtie
    ActionController::Base.send :include, Fabes::Helper
    ActionController::Base.helper Fabes::Helper
    #TODO: auto-inject route in rails?
  end
end
