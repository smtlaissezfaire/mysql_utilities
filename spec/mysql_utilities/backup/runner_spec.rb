require File.dirname(__FILE__) + "/spec_helper"

module MysqlUtilities
  module Backup
    describe Runner do
      it "should assign the environment from the options hash" do
        Runner.new({:environment => "development"}).environment.should == "development"
      end
      
      it "should assign the environment from the options hash (should be accessible as rails_env)" do
        Runner.new(:environment => "development").rails_env.should == "development"
      end
      
      it "should have the options" do
        Runner.new({:environment => "foo", :key => "value"}).options.should == {:environment => "foo", :key => "value"}
      end
      
      it "should raise an error if no environment is specified" do
        lambda {
          Runner.new({})
        }.should raise_error(EnvironmentError, "The rails environment specified cannot be found")        
      end
    end
    
    describe "the runner", :shared => true do
      it "should have the base path as $PATH" do
        @runner.base_path.should == "$PATH"
      end
      
      it "should have the timestamp as Time.now" do
        @time = Time.now
        Time.stub!(:now).and_return @time
        @runner.timestamp.should == @time.strftime("%Y-%m-%d-%H-%M-%S")
      end
      
      it "should have the mysqldump program" do
        @runner.mysql_dump.should == "/usr/bin/env mysqldump"
      end
    
      it "should have the mysql_user from the environment" do
        @runner.stub!(:rails_root).and_return(File.dirname(__FILE__) + "/../shared/fixtures")        
        @runner.mysql_user.should == @user
      end
    
      it "should have the mysql_password from the environment" do
        @runner.stub!(:rails_root).and_return(File.dirname(__FILE__) + "/../shared/fixtures")
        @runner.mysql_password.should == @password
      end
    
      it "should have the mysql_host from the environment" do
        @runner.stub!(:rails_root).and_return(File.dirname(__FILE__) + "/../shared/fixtures")
        @runner.mysql_host.should == "localhost"
      end
      
      it "should have the mysql_database" do
        @runner.stub!(:rails_root).and_return(File.dirname(__FILE__) + "/../shared/fixtures")
        @runner.mysql_database.should == @database
      end
    end
    
    describe Runner do
      before :each do
        @runner = Runner.new(:environment => "development")
        @database = "project_development"
        @user = "root"
        @password = nil
      end

      it_should_behave_like "the runner"
    end
    
    describe Runner, "in the test environment" do
      before :each do
        @runner = Runner.new(:environment => "test")
        @database = "project_test"
        @user = "test"
        @password = "scott"
      end
      
      it_should_behave_like "the runner"
    end
    
    describe "a backup run", :shared => true do
      it "should run the backup" do
        @runner.should_receive(:run_command).with(@runner.dump_command).and_return nil
        @runner.run_program
      end
    end
    
    describe Runner, ", run_program" do
      before :each do
        @runner = Runner.new(:environment => "development")
        @runner.stub!(:run).and_return nil
        @runner.stub!(:dump_command).and_return "dump command"
      end
      
      it_should_behave_like "a backup run"
      
      it "should not have compression specified" do
        @runner.compression_specified?.should be_false
      end
    end
    
    describe Runner, ", run_program, with compression specified" do
      before :each do
        @runner = Runner.new(:environment => "development", :compression => true)
        @runner.stub!(:run_command).and_return nil
        @runner.stub!(:dump_command).and_return "dump command"
        @runner.stub!(:compress).and_return nil
      end
      
      it_should_behave_like "a backup run"
      
      it "should have compression_specified?" do
        @runner.compression_specified?.should be_true
      end
      
      it "should compress the backup" do
        @runner.should_receive(:compress).and_return nil
        @runner.run_program
      end      
    end

    describe "A Runner instance" do
      it "should respond to run_command" do
        Runner.new({:environment => "foo"}).should respond_to(:run_command)
      end
    end
    
    describe "A Runner's file prefix" do
      it "should be bar, with option :file_prefix => 'bar'" do
        runner = Runner.new(:environment => "foo", :file_prefix => "bar")
        runner.file_prefix.should == 'bar'
      end
    end
    
    describe "Runner's compression" do
      before :each do
        @runner = Runner.new({:environment => "foo", :compress => true})
        @runner.stub!(:dump_command)
      end
      
      it "should create the tar archive" do
        pending 'TODO'
        @dump_filename = @runner.dump_filename
        @runner.should_receive(:run_command).with("tar -cf $PATH/#{@dump_filename}.tar $PATH/#{@dump_filename}")
      end
    end
    
    describe Runner, "'s run" do
      before :each do
        @runner = Runner.new(:environment => "developemnt", :compress => false)
        @runner.stub!(:run_command).and_return nil
        @runner.mysql_database = "foo_dev"
        @runner.mysql_password = "crap_password"
        @runner.mysql_host = "localhost"
        @runner.mysql_user = "scott"
      end
      
      def mysql_dump_string
        <<-HERE 
          /usr/bin/env mysqldump --user scott.*
                        --password=crap_password.*
                        --host localhost.*
                        --single-transaction > $HOME/development.sql.*
        HERE
                          
      end
      
      it "should run the dump command" do
        pending 'FIXME'
        regexp = Regexp.new(mysql_dump_string, Regexp::EXTENDED)
        @runner.should_receive(:run_command).with(regexp)
        @runner.run_program          
      end
    end
    
    describe Runner, "'s Compression" do
      before :each do
        @runner = Runner.new({:environment => "foo", :compress => true, :file_prefix => "project_name"})
        @formatted_now = Time.now.strftime("%Y-%m-%d")
        @runner.stub!(:timestamp).and_return @formatted_now
        @runner.stub!(:run_command).and_return nil
      end
      
      it "should compress the archive with gzip -9" do
        @runner.stub!(:dump_filename).and_return "foo_bar.sql"
        
        @runner.should_receive(:run_command).with("gzip -9 $PATH/foo_bar.sql")
        @runner.compress
      end
      
      it "should compress the archive with gzip -9 as file_prefix_rails_env_timestamp.sql" do
        @runner.should_receive(:run_command).with("gzip -9 $PATH/project_name_foo_#{@formatted_now}.sql")
        @runner.compress
      end
    end
    
    describe Runner, "'s file_prefix" do
      it "should be set at initialization" do
        runner = Runner.new(:environment => "foo", :file_prefix => "baz_quxx")
        runner.file_prefix.should == "baz_quxx"
      end
    end
    
    describe Runner, "'s dump_filename" do
      before :each do
        @time = Time.now
        Time.stub!(:now).and_return @time
        @runner = Runner.new({:environment => "foo", :file_prefix => "bar"})
      end
      
      it "returns file_prefix_rails_env_timestamp.sql" do
        @runner.dump_filename.should == "bar_foo_#{@time.strftime("%Y-%m-%d-%H-%M-%S")}.sql"
      end
    end
    
    describe "Runner.run" do
      before :each do
        @runner = mock(Runner)
        Runner.stub!(:new).and_return @runner
        @runner.stub!(:run_program)
        @options = {:foo => :bar}
      end
      
      it "should create a new runner" do
        Runner.should_receive(:new).with(@options).and_return @runner
        Runner.run(@options)
      end
      
      it "should run the program" do
        @runner.should_receive(:run_program)
        Runner.run(@options)
      end
    end
    
  end
end