require 'fabes/utils'
require 'fabes/configuration'
require 'fabes/experiment'
require 'fabes/alternative'
require 'fabes/connection_handling'
require 'fabes/helper'

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
