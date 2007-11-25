require File.dirname(__FILE__) + "/spec_helper"

describe "The EnvironmentError constant" do
  it "should exist" do
    lambda {
      ::MysqlUtilities::Backup::EnvironmentError
    }.should_not raise_error
  end
  
  it "should be a subclass of StandardError" do
    ::MysqlUtilities::Backup::EnvironmentError.superclass.should == StandardError
  end
end