require 'fabes/utils'

require 'fabes/experiment'
require 'fabes/alternative'

require 'fabes/helper'
require 'fabes/connection_handling'

module Fabes
  extend self
  
  attr_accessor :configuration

  def configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  def db
    @db ||= ConnectionHandling.establish_connection self.configuration
  end
end
