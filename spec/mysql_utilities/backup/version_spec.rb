require File.dirname(__FILE__) + "/spec_helper"

module ::MysqlUtilities
  module Backup
    describe Version do
      it "should be on major version 0" do
        Version::MAJOR.should == 0
      end
      
      it "should be on minor version 0" do
        Version::MINOR.should == 0
      end
      
      it "should be on tiny version 1" do
        Version::TINY.should == 1
      end
    end
    
    describe "Version.to_s", :shared => true do
      it "returns the version as a string" do
        Version.send(@method).should == "0.0.1"
      end
    end
      
    describe "Version's to_s" do
      before :each do
        @method = :to_s
      end
      
      it_should_behave_like "Version.to_s"
    end
    
    describe "Version's inspect" do
      before :each do
        @method = :inspect
      end
      
      it_should_behave_like "Version.to_s"
    end

  end
end