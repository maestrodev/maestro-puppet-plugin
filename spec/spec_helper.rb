require 'rubygems'
require 'rspec'
require 'mocha'

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../src') unless $LOAD_PATH.include?(File.dirname(__FILE__) + '/../src')


require 'puppet_worker'
require 'mcollective/test'

RSpec.configure do |config|


end