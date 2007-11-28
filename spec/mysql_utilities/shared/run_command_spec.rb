require File.dirname(__FILE__) + "/spec_helper"

module MysqlUtilities
  module Shared
    describe RunCommand do
      include RunCommand
      
      before :each do
        Kernel.stub!(:puts).and_return ""
        Kernel.stub!(:`).and_return "output"
      end

      it "should output the command run" do
        Kernel.stub!(:puts).and_return "output"
        Kernel.should_receive(:puts).with("* executing: echo 'hello'")
        run_command("echo 'hello'")
      end
      
      it "should actually run the command" do
        Kernel.should_receive(:`).and_return "output"
        run_command("echo 'hello'")
      end
      
      it "should output the output" do
        Kernel.stub!(:send).and_return "output"
        Kernel.stub!(:puts).and_return nil
        Kernel.should_receive(:puts).with("output").and_return nil
        run_command("echo 'hi'")
      end
      
      it "should return the output" do
        run_command("echo 'hello'").should == "output"
      end
      
      it "should strip any extra spaces in the command, before running" do
        strip_extra_chars!("echo 'hi'   ").should == "echo 'hi'"
      end
      
      it "should strip any extra spaces off the end, before running" do
        strip_extra_chars!("echo 'hi' ").should == "echo 'hi'"
      end
      
      it "should strip any tabs" do
        Kernel.should_receive(:puts).with("* executing: foo")
        run_command("foo\t\t")
      end
      
      it "should remove any newlines" do
        strip_extra_chars!("\nfoo\n\n\n").should == "foo"
      end
    end     
  end
end
