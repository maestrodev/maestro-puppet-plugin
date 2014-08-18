require 'maestro_plugin'
require 'puppet_blacksmith'

# overwrite git execution to use our utils
module Blacksmith
  class Git

    def exec_git(cmd)
      new_cmd = "LANG=C #{git_cmd_with_path(cmd)}"
      Maestro.log.debug("Running git: #{new_cmd}")

      exit_status, out = Maestro::Util::Shell.run_command(new_cmd)

      if !exit_status.success?
        raise Blacksmith::Error, "Command #{new_cmd} failed with exit status #{exit_status.exit_code}\n#{out}"
      end
      return out
    end
  end
end

module MaestroDev
  module Plugin

    class PuppetForgeWorker < Maestro::MaestroWorker

      PUSH_MSG = "[blacksmith] Bump version"

      attr_accessor :forge, :modulefile

      def validate_fields
        errors = []
        errors << "Missing Forge username" if get_field('forge_username', '').empty?
        errors << "Missing Forge password" if get_field('forge_password', '').empty?
        raise ConfigError, "Configuration errors: #{errors.join(', ')}" unless errors.empty?
      end

      def forge_push
        validate_fields
        username = get_field('forge_username')
        self.forge = Blacksmith::Forge.new(username, get_field('forge_password'), get_field('forge_url'))
        log_output("Uploading file to the Puppet Forge as '#{forge.username}' at '#{forge.url}'")

        path = get_field('path') || get_field('scm_path')
        raise ConfigError, "Missing module path" unless path

        Maestro.log.debug("Looking for metadata files")

        git = Blacksmith::Git.new(path)
        modulefile_path = Blacksmith::Modulefile::FILES.find {|f| File.exists?("#{git.path}/#{f}")}
        raise PluginError, "metadata.json or Modulefile not found at #{git.path}/#{modulefile_path}" unless modulefile_path
        self.modulefile = Blacksmith::Modulefile.new(File.join(git.path, modulefile_path))

        Maestro.log.debug("Checking if last commit was automated")

        if last_commit_was_automated?(git.path)
          log_output("Module was already released")
          not_needed
          return
        end

        Maestro.log.debug("Tagging version #{modulefile.version}")
        git.tag!(modulefile.version)
        log_output("Tagged version #{modulefile.version}")

        # pushing the package set or find the build under pkg/
        pkg_path = File.expand_path(File.join(path,"pkg"))
        regex = /^#{username}-#{modulefile.name}-.*\.tar\.gz$/
        package = get_field('package')
        if package
          # if it doesn't exist, then try as a relative path
          package = File.expand_path(File.join(path, package)) unless File.exists?(package)
          raise PluginError, "Unable to find package to upload at #{get_field('package')} nor #{package}" unless File.exists?(package)
        else
          f = Dir.new(pkg_path).select{|f| f.match(regex)}.last
          raise PluginError, "Unable to find package to upload at #{pkg_path} with #{regex}" unless f
          package = File.expand_path(File.join(pkg_path, f))
        end

        log_output("Uploading module #{modulefile.name}/#{modulefile.version} from #{package}")

        forge.push!(modulefile.name, package)
        new_version = modulefile.bump!
        log_output("Bumping version from #{modulefile.version} to #{new_version}")
        git.commit_modulefile!
        git.push!
        log_output("Finished Puppet module release")
      rescue Blacksmith::Error => e
        raise PluginError, e.message
      end

      private

      def last_commit_was_automated?(path)
        # get last commit
        # --pretty=%B would be better but not available in git 1.7
        cmd = "cd #{path} && LANG=C git log -1 --pretty=oneline"
        Maestro.log.debug("Running git: #{cmd}")
        result = Maestro::Util::Shell.run_command(cmd)
        Maestro.log.debug("Git output: [#{result[0].exit_code}] #{result[1]}")
        output = result[1]
        output.empty? or output.include?(PUSH_MSG)
      end

      def log_output(msg)
        Maestro.log.info(msg)
        write_output("#{msg}\n")
      end
    end
  end
end
