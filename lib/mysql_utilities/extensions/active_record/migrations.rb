

module MysqlUtilities
  module Extensions
    module ActiveRecord
      # Extend ActiveRecord with the following code, in environment.rb:
      #
      # ActiveRecord::Migration.class_eval do
      #   extend MysqlUtilities::Extensions::ActiveRecord::MigrationClassMethod
      # end
      module MigrationClassMethods
        MYSQL_DELIMITER = ";"
        
        def multi_execute(string)
          strings = string.split(";")
          strings.each do |s|
            s.chomp!
            s.strip!
            unless s.empty?
              execute(s)
            end
          end
        end
        
        def execute_from_file(filename)
          multi_execute(File.read(filename))
        end
        
      end
    end
  end
end