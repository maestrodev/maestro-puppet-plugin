Puppet Enterprise MCollective Client Gem
========================================

Here's what you need to build the MCollective client gem that will work with a
Puppet Enterprise environment.

Building the Gem
----------------

You must first have Puppet Enterprise server installed before building the gem. You
also need rubygems installed.

1. Create a lib subdirectory under the current directory.

1. Copy the following files installed with Puppet Enterprise server into the lib directory.
  * /opt/puppet/lib/ruby/site_ruby/1.8/mcollective.rb
  * /opt/puppet/lib/ruby/site_ruby/1.8/mcollective
  
1. run the following command:
    
    `gem build pe-mcollective-client.gemspec`

Configuring the client
----------------------

To configure the client, edit the client.cfg file found in this directory with the correct
connection details such as server host name, port, user and passwords.

You must place this file in either of these locations:
    
* /etc/puppetlabs/mcollective
* In a file named .mcollective in the home directory of the user running the client.

