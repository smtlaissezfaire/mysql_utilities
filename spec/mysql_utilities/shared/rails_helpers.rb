require File.dirname(__FILE__) + "/spec_helper"

module MysqlUtilities  
  module Shared
    describe RailsHelpers, "function: rails_root" do
      include RailsHelpers
      
      after :each do
        Object.send(:remove_const, :RAILS_ROOT)
      end
      
      it "should be able to able to spit out RAILS_ROOT" do
        Object.const_set(:RAILS_ROOT, "/usr/local/urbis")
        rails_root.should == "/usr/local/urbis"
      end      
      
      it "should be able to spit out RAILS_ROOT" do
        Object.const_set(:RAILS_ROOT, "/foo/bar")
        rails_root.should == "/foo/bar"
      end
    end

    describe RailsHelpers, "function: database_config_path" do
      include RailsHelpers
      
      before :each do
        context = self
        context.stub!(:rails_root).and_return "/foo/bar"
      end
      
      it "should be able to able to spit out the database.yml file" do
        database_config_path.should == "/foo/bar/config/database.yml"
      end      
    end

    describe RailsHelpers, "function: database_config" do
      include RailsHelpers
      
      before :each do
        @filename = File.dirname(__FILE__) + "/fixtures/config/database.yml"
        @yaml_file = YAML.load(File.read(@filename))

        context = self
        context.stub!(:rails_root).and_return(File.dirname(__FILE__) + "/fixtures")
      end
      
      it "should be able to able to spit out the database.yml file" do
        database_config.should == @yaml_file
      end      
    end


  end
end
