Building the plugin
===================

This plugin requires a non open-source gem which cannot be uploaded to rubygems.
This gem is installed on Maestro's internal (private) gem server.
When developing, you will need to ensure that the 'pe-mcollective-client' gem is available to the build process.
One suggestion is to use the ~/.gemrc file to include the private repo in the repo search-path, but that seems to be ignored by rvm.
My temporary suggestion has been to add the internal repo to the Gemfile, and remove it from there (and the lock file) before committing any changes.

Note: The following suggestion on ServerFault was tried, but it didn't work on MacOS
http://serverfault.com/questions/264972/rvm-not-picking-up-etc-gemrc

Any suggestions as to how to get the .gemrc file to be handled properly by rvm would be greatly appreciated.