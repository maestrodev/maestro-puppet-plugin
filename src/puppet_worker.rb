require 'maestro_agent'
require 'mcollective'

include MCollective::RPC

module MaestroDev
  class PuppetWorker < Maestro::MaestroWorker

    def validate_fields
      missing = ['verbose', 'identity_filter'].select{|f| empty?(f)}
      set_error("Missing Fields: #{missing.join(",")}") unless missing.empty?
    end

    def runonce
      Maestro.log.info 'Running Puppet plugin: runonce'
      validate_fields
      return if error?

      # http://docs.puppetlabs.com/mcollective/simplerpc/clients.html
      puppet = client
      puppet.verbose = get_field('verbose')
      puppet.progress = false
      puppet.identity_filter get_field('identity_filter')

      results = puppet.runonce(:forcerun => true)
      report = puppet.stats.report
      Maestro.log.debug Helpers.rpcresults results
      Maestro.log.debug report
      write_output Helpers.rpcresults results
      write_output report
      
      puppet.disconnect

      Maestro.log.info 'Completed Puppet plugin: runonce'
    end

    private

    def client
      rpcclient('puppetd')
    end

    def empty?(field)
      value = get_field(field)
      return true if value.nil?
      return true if value.is_a?(String) and value.empty?
      false
    end

  end
end
