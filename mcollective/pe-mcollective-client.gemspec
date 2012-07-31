Gem::Specification.new do |s|
  s.name        = 'pe-mcollective-client'
  s.version     = '1.2.1'
  s.date        = '2012-07-27'
  s.summary     = "PE mcollective client"
  s.description = "Puppet Enterprise Marionette Collective client."
  s.authors     = ["Etienne Pelletier"]
  s.email       = 'epelletier@maestrodev.com'
  s.files       = Dir["lib/mcollective.rb"] + Dir["lib/mcollective/**/*"]
#  s.add_runtime_dependency 'stomp', '~> 1.2', '>= 1.2.2'
end
