
module MysqlUtilities
  module Shared
    module RunCommand
      def run_command(command)
        strip_extra_chars!(command)
        Kernel.puts("* executing: #{command}")
        output = Kernel.send(:`, command)
        Kernel.puts("#{output}")
        return output
      end
    
      def strip_extra_chars!(text)
        text.gsub!("\s\s", "")
        text.gsub!("\t", "")
        text.gsub!("\n", "")
        
        text.chomp!
        text.strip!
        text
      end
    end
  end
end