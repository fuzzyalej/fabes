require 'fabes/utils'

require 'fabes/experiment'
require 'fabes/alternative'

require 'fabes/helper'
require 'fabes/connection_handling'

module Fabes
  extend self

  def db
    @db = ConnectionHandling.establish_connection adapter: 'redis'
  end
end
