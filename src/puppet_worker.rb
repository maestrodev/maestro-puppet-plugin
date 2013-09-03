require 'maestro_plugin'
require 'mcollective'

include MCollective::RPC

module MaestroDev
  module Plugin
    class PuppetWorker < Maestro::MaestroWorker

      def runonce
        validate_parameters

        # http://docs.puppetlabs.com/mcollective/simplerpc/clients.html
        puppet = client
        puppet.verbose = @verbose
        puppet.progress = false
        puppet.identity_filter @identity_filter

        results = puppet.runonce(:forcerun => true)
        report = puppet.stats.report
        write_output("\n#{Helpers.rpcresults(results)}", :buffer => true)
        write_output("\n#{report}")

        # We do not disconnect because the puppetlabs code does not handle disconnecting properly.  It disconnects the
        # stomp connection without discarding it. Next time this connection is used, it fails because it is no longer
        # connected. This will not cause a problem on the stomp server because the existing connection is reused.
        # The only time this will create a problem is if the mcollective activemq server dies which means this agent's
        # connection will now be stale.
        #puppet.disconnect
      end

      ###########
      # PRIVATE #
      ###########
      private

      def validate_parameters
        errors = []
        @verbose = get_boolean_field('verbose')
        @identity_filter = get_field('identity_filter', '')

        errors << 'missing field identity_filter' if @identity_filter.empty?
        raise ConfigError, "Config Errors: #{errors.join(', ')}" unless errors.empty?
      end

      def client
        rpcclient('puppetd')
      end
    end
  end
end
