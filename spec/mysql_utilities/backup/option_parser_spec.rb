require File.dirname(__FILE__) + "/spec_helper"

module MysqlUtilities
  module Backup
    describe OptionParser, "parse" do
      
      before(:each) do
        @parser = MysqlUtilities::Backup::OptionParser.new
        @version_string = MysqlUtilities::Backup::Version.to_s
      end

      def parse(args)
        @parser.parse(args)
        @parser.options
      end
      
      it "should be able to find help with -h" do
        options = parse(["-h"])
        options.help.should be_true
      end
      
      it "should not have help, by default" do
        options = parse([])
        options.help.should be_nil
      end
      
      it "should be able to find help with --help" do
        options = parse(["--help"])
        options.help.should be_true
      end
      
      def banner_string
        "Usage: script/database/backup [options]"
      end
      
      it "should return the banner if no arguments are given" do
        @parser.parse([])
        @parser.help.should include(banner_string)
      end
      
      it "should take an environment option with a RAILS_ENV argument" do
        options = parse(["--environment", "development"])
        options.environment.should == "development"
      end

      it "should take an e option with a RAILS_ENV argument" do
        options = parse(["-e", "production"])
        options.environment.should == "production"
      end
      
      it "should take a tarball option (with -t)" do
        options = parse(["-t"])
        options.tarball.should be_true
      end
      
      it "should take a tarball option (with --tarball)" do
        options = parse(["--tarball"])
        options.tarball.should be_true
      end
      
      it "should have the version number with -v" do
        options = parse(["-v"])
        options.version.should == @version_string
      end
      
      it "should have the version number (with --version)" do
        options = parse(["--version"])
        options.version.should == @version_string
      end
    end
  end
end