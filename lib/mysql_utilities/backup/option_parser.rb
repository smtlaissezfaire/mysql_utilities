require 'ostruct'

module MysqlUtilities
  module Backup
    class OptionParser < ::OptionParser      
      def initialize
        super
        @options = OpenStruct.new
        
        self.banner = "Usage: script/database/backup [options]"
        on("-e", "--environment [RAILS_ENV]", "Specify the environment to backup - Assumes the database is named urbis_\#\{RAILS_ENV\}") { |e| @options.environment = e }
        on("-t", "--tarball", "Create a tarball") { |t| @options.tarball = t }
        on("-v", "--version", "Version") { @options.version = MysqlUtilities::Backup::Version.to_s }
        on("-h", "--help") { @options.help = true }
      end
      
      attr_reader :options      
    end
  end
end
