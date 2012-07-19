require 'fabes/utils'
require 'fabes/configuration'
require 'fabes/experiment'
require 'fabes/alternative'
require 'fabes/connection_handling'
require 'fabes/helper'
require 'fabes/admin'

module Fabes
  extend self
  attr_accessor :configuration

  def configure
    self.configuration ||= Configuration.new
    yield(configuration) if block_given?
    configuration
  end

  def db
    @db ||= ConnectionHandling.establish_connection Fabes.configuration.db, Fabes.configuration.adapter
  end
end

Fabes.configure

if defined? Rails
  ActionController::Base.send :include, Fabes::Helper
  ActionController::Base.helper Fabes::Helper
  #TODO: Autoadd route to admin panel
  #TODO: Railtie???
end
