module MysqlUtilities  
  module Backup    
    class EnvironmentError < StandardError; end
    
    class Runner
      
      class << self
        def run(options)
          new(options).run_program
        end
      end
    
      lazy_attr_reader(:mysql_user)     { database["username"] }      
      lazy_attr_reader(:mysql_password) { database["password"] }
      lazy_attr_reader(:mysql_host)     { database["host"] }
      lazy_attr_reader(:timestamp)      { Time.now.strftime("%Y-%m-%d-%H-%M-%S") }
      lazy_attr_reader :base_path, "$HOME"
      attr_reader :rails_env
      attr_reader :options
    
      def initialize(options_hash={})
        assign_environment(options_hash)
        @options = options_hash
        raise EnvironmentError, "The rails environment specified cannot be found" unless environment_exists?
      end
    
      def run_program
        run complete_dump_command
        if compression_specified?
          compress
          cleanup
        end
      end
    
    private
  
      def cleanup
        run "rm -rf #{base_path}/#{dump_filename}"
      end
    
      def compression_specified?
        options[:tarball] ? true : false
      end
  
      def compress
        add_tar_archive
        compress_tar_archive
      end
    
      def add_tar_archive
        run "tar -cf #{base_path}/#{dump_filename}.tar #{base_path}/#{dump_filename}"
      end

      def compress_tar_archive
        run "gzip #{base_path}/#{dump_filename}.tar"
      end
  
      def environment_exists?
        rails_env ? true : false
      end
    
      def assign_environment(options)
        @rails_env = options[:environment]
      end
  
      def dump_filename
        "urbis_#{rails_env}_#{timestamp}.sql"
      end
  
      def complete_dump_command
        <<-HERE 
          #{mysql_dump} --user #{mysql_user} 
                        --password=#{mysql_password} 
                        urbis_#{rails_env} 
                        --host #{mysql_host} 
                        --single-transaction > #{base_path}/#{dump_filename}
        HERE
      end
    

      def database_config_for_environment
        @config ||= YAML.load(File.read(RAILS_ROOT + "/config/database.yml"))
        @config[rails_env]
      end

      alias_method :database, :database_config_for_environment

      def strip_newlines_and_extra_chars(cmd)
        cmd.gsub!("\n", "")
        cmd.gsub!("\t", "")
        cmd
      end

      def run(cmd)
        puts "* executing #{strip_newlines_and_extra_chars(cmd)}"
        puts `#{cmd}`
      end

      def mysql_dump; @mysql_dump ||= "/usr/bin/env mysqldump"; end
    end    
  end  
end
