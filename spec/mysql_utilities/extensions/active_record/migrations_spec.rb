require File.dirname(__FILE__) + "/../spec_helper"

module MysqlUtilities
  module Extensions
    module ActiveRecord
      describe MigrationClassMethods do
        it "should have the method multi_execute" do
          self.should respond_to(:multi_execute)
        end
        
        it "should have the method execute_from_file" do
          self.should respond_to(:execute_from_file)
        end        
      end
      
      describe MigrationClassMethods, "multi_execute" do
        before :each do
          stub!(:execute)
        end
        
        it "should take a string" do
          lambda {
            multi_execute("foo")
          }.should_not raise_error
        end
        
        it "should run execute with the method called" do
          stub!(:execute).and_return "executed!"
          self.should_receive(:execute).with("foo")
          multi_execute("foo")
        end
        
        it "should run execute with the two commands given" do
          self.should_receive(:execute).with("foo").once
          self.should_receive(:execute).with("bar").once
          multi_execute("foo;bar")
        end
      end
      
      describe MigrationClassMethods, "execute_from_file" do
        before :each do
          stub!(:multi_execute)
          File.stub!(:read).and_return "contents"
        end
        
        it "should take a filename" do
          lambda {
            execute_from_file("filename.sql")
          }.should_not raise_error
        end
        
        it "should read the file" do
          File.should_receive(:read).with("filename.sql").and_return "contents"
          execute_from_file("filename.sql")
        end
        
        it "should call multi_execute with the contents of the file" do
          self.should_receive(:multi_execute).with("contents")
          execute_from_file("filename.sql")
        end
      end
    end
  end
end
