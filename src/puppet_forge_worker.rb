require 'maestro_agent'

module MaestroDev
  class PuppetWorker < Maestro::MaestroWorker

    def validate_fields
    end

    def forgeUpload
      begin
        Maestro.log.info "Uploading file to the Puppet Forge"
        validate_fields

        set_error("API not yet available")

      rescue Exception => e
        set_error("#{e.message}\n" + e.backtrace.join("\n"))
      end
    end

    def forgeCopy
      begin
        Maestro.log.info "Copying artifact to the Puppet Forge"
        validate_fields

        set_error("API not yet available")

      rescue Exception => e
        set_error("#{e.message}\n" + e.backtrace.join("\n"))
      end
    end

  end
end
