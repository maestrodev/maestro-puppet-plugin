Maestro Puppet Plugin
=====================

Provides the following Maestro tasks

# Puppet runonce

On systems running Puppet Enterprise, the Puppet runonce task can be used within a composition to kick off puppet on a
remote node through MCollective.  Simply edit your composition, find the "puppet runonce" task in the task library and add it.
Then, specify the hostname of the node on which you want to run puppetd in the Identity Filter field.  You can either specify a hostname
or use a regular expression to match host names. For example /maestrodev.net$/ to match all *.maestrodev.net.

## Pre-requisites

Puppet Enterprise must be installed on the maestro agent host running the Puppet plugin. It will look for the mcollective
libraries typically installed in the /opt/puppet/libexec directory.

The mcollective client configuration must also be present on the maestro agent host. The agent looks for the files
/etc/puppetlabs/mcollective/client.cfg or ~/.mcollective to contain the configuration.

More info at

* [MaestroDev Integration with Puppet Enterprise and MCollective](http://www.maestrodev.com/docs/users-guide/integration-with-puppet-enterprise-and-mcollective/)
* [mcollective documentation on simplerpc](http://docs.puppetlabs.com/mcollective/simplerpc/clients.html)


# License

    Copyright 2013 MaestroDev, Inc.
    
    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at
    
        http://www.apache.org/licenses/LICENSE-2.0
    
    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
