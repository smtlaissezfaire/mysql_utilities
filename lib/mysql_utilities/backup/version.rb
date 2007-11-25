module MysqlUtilities
  module Backup
    module Version
      MAJOR = 0
      MINOR = 0
      TINY = 1
      
    module_function
      
      def to_s
        "#{MAJOR}.#{MINOR}.#{TINY}"
      end
    end
  end
end