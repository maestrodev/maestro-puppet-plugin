require 'maestro_agent'
require 'mcollective'

include MCollective::RPC

module MaestroDev
  class PuppetWorker < Maestro::MaestroWorker

    def validate_fields
      set_error('')

      raise 'Invalid Field Set, Missing verbose' if get_field('verbose').nil?
      raise 'Invalid Field Set, Missing agent' if get_field('agent').nil?
    end

    def runonce
      begin
        Maestro.log.info "Running Puppet"
        validate_fields
        
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
      rescue Exception => e
        set_error("#{e.message}\n" + e.backtrace.join("\n"))
      end

      Maestro.log.info "*********************** Completed Puppet ***************************"
    end

  end
end
