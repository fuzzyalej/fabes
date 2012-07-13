require 'simplecov'
SimpleCov.start do
  add_filter '/test/'
end

require 'test/unit'
require 'shoulda'
require 'mocha'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'fabes'

def session
    @session ||= {}
end
