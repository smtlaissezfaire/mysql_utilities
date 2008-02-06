module MysqlUtilities  
  module Backup
    class Runner
      
      def self.run(options)
        new(options).run_program
      end

      include MysqlUtilities::Shared::RunCommand
      include MysqlUtilities::Shared::RailsHelpers
      
      alias_method :database, :database_config
      
      def initialize(options)
        @options = options
        @environment = options[:environment]
        @file_prefix = options[:file_prefix]
        raise EnvironmentError, "The rails environment specified cannot be found" unless environment_exists?
      end

      lazy_attr_reader(:mysql_database) { database[rails_env]["database"] }      
      lazy_attr_reader(:mysql_host)     { database[rails_env]["host"]}
      lazy_attr_reader(:mysql_user)     { database[rails_env]["username"] }
      lazy_attr_reader(:mysql_password) { database[rails_env]["password"]}
      
      lazy_attr_reader(:timestamp) { Time.now.strftime("%Y-%m-%d-%H-%M-%S") }
      lazy_attr_reader :mysql_dump, "/usr/bin/env mysqldump"
      lazy_attr_reader :base_path, "$PATH"
      
      attr_reader :environment
      attr_reader :options
      attr_reader :file_prefix
      
      def rails_env
        @environment
      end
      
      def run_program
        run_command dump_command
        if compression_specified?
          compress
        end        
      end
      
      def compression_specified?
        options[:compression] ? true : false
      end
      
      def dump_filename
        "#{file_prefix}_#{rails_env}_#{timestamp}.sql"
      end
      
      def compress
        run_command "gzip -9 #{base_path}/#{dump_filename}"
      end

    private
    
      def environment_exists?
        @environment ? true : false
      end
      
      def dump_command
        "mysqldump"
      end
      
    end
    
    #class Runner
    #  
    #private
    #
    #  def complete_dump_command
    #    <<-HERE 
    #      #{mysql_dump} --user #{mysql_user} 
    #                    --password=#{mysql_password} 
    #                    project_name_#{rails_env} 
    #                    --host #{mysql_host} 
    #                    --single-transaction > #{base_path}/#{dump_filename}
    #    HERE
    #  end
    #
    #end    
  end  
end
