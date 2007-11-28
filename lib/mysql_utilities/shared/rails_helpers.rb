require 'yaml'

module MysqlUtilities
  module Shared
    module RailsHelpers
      def rails_root
        Object.const_get(:RAILS_ROOT)
      end
      
      def database_config_path
        "#{rails_root}/config/database.yml"
      end
      
      def database_config
        YAML.load(File.read(database_config_path))
      end      
    end
  end
end