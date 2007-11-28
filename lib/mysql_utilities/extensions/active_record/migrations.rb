

module MysqlUtilities
  module Extensions
    module ActiveRecord
      module MigrationClassMethods
        MYSQL_DELIMITER = ";"
        
        def multi_execute(string)
          strings = string.split(";")
          strings.each do |s|
            execute(s)
          end
        end
        
        def execute_from_file(filename)
          multi_execute(File.read(filename))
        end
        
      end
    end
  end
end