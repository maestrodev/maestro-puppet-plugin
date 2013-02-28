require 'maestro_agent'
require 'mcollective'

include MCollective::RPC

module MaestroDev
  class PuppetWorker < Maestro::MaestroWorker

    def validate_fields
      missing = ['verbose', 'agent'].select{|f| empty?(f)}
      set_error("Missing Fields: #{missing.join(",")}") unless missing.empty?
    end

    def runonce
      Maestro.log.info "Running Puppet plugin"
      validate_fields
      return if error?
      
      write_output "Agent: #{get_field('agent')}\n"
      write_output "Verbose: #{get_field('verbose')}\n"

      puppet = rpcclient("puppetd")
      puppet.verbose = get_field('verbose')
      puppet.progress = false
      
      puppet.identity_filter get_field('agent')
      
      results = puppet.runonce(:forcerun => true)
      report = puppet.stats.report
      
      write_output Helpers.rpcresults results
      write_output report
      
      puppet.disconnect

      Maestro.log.info "Completed Puppet plugin"
    end

    private

    def empty?(field)
      get_field(field).nil? or get_field(field).empty?
    end

  end
end
