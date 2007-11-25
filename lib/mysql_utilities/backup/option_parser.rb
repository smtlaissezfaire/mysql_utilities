module MysqlUtilities
  module Backup
    class OptionParser
      class << self
        def parse
          options = {}
          opts = ::OptionParser.new do |opts|
            opts.banner = "Usage: script/database/backup [options]"
            opts.separator "Optional Arguments:"
            opts.on("-e", "--environment [RAILS_ENV]", "Specify the rails environment") { |o| options[:environment] = o }
            opts.on("-c", "--compress", "Make a tarball (tar.gz) out of the dump") { |o| options[:tarball] = o}
            opts.on("-v", "--version", "Version number") do
              puts version_number
              exit
            end

            opts.on_tail("-h", "--help", "This help") do
              puts opts
              exit
            end

            def version_number
              ::MysqlUtilities::Backup::Version.to_s
            end
          end

          opts.parse!

          unless options[:environment]
            puts "You must specify the environment!  Use --help for more information"
            exit
          end

          Backup::Runner.run(options)
        end
      end
    end
  end
end