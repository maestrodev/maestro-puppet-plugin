require 'rubygems'
require 'rspec'
require 'mocha/api'

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../src') unless $LOAD_PATH.include?(File.dirname(__FILE__) + '/../src')

require 'puppet_worker'

RSpec.configure do |config|
  config.mock_framework = :mocha
end
