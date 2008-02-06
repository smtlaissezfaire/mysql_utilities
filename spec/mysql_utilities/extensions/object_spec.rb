require File.dirname(__FILE__) + "/spec_helper"

describe Object do
  before :each do
    @klass = Class.new
  end
  
  it "should respond to lazy_attr_reader" do
    @klass.respond_to?(:lazy_attr_reader).should be_true
  end
  
  it "should take a first argument - the name of the method" do
    @klass.lazy_attr_reader(:foo)
  end
  
  it "should take an optional second argument - the default value of the method" do
    @klass.lazy_attr_reader(:foo, :bar)
  end
  
  it "should add an attr_reader with a nil value, when no default value is given" do
    @klass.lazy_attr_reader(:foo)
    @klass.new.foo.should be_nil
  end
  
  it "should add an attr_reader, with a default value, if specified" do
    @klass.lazy_attr_reader(:foo, :bar)
    @klass.new.foo.should == :bar
  end
  
  it "should be able to change the default value, by changing the instance variable" do
    @klass.lazy_attr_reader(:foo, :bar)
    instance = @klass.new
    instance.instance_variable_set("@foo", 7)
    instance.foo.should == 7    
  end

  it "should be able to take a block as it's default parameter" do
    @klass.lazy_attr_reader(:foo) { 1 }
    @klass.new.foo.should == 1
  end
  
  it "should raise an error if both are specified" do
    lambda { 
      @klass.lazy_attr_reader(:foo, :bar) { :baz }
    }.should raise_error(ArgumentError, "lazy_attr_reader cannot take two default values")    
  end
end

describe Object, "'s lazy_attr_writer" do
  before :each do
    @klass = Class.new
  end
  
  it "should create an writer for the method given" do
    @klass.lazy_attr_writer(:foo)
    @klass.new.should respond_to(:foo=)
  end
  
  it "should create a writer for multiple methods given" do
    @klass.lazy_attr_writer(:foo, :bar)
    @klass.new.should respond_to(:foo=)
    @klass.new.should respond_to(:bar=)
  end
  
  it "should change the instance variable when it is written to" do
    @klass.lazy_attr_writer(:foo)
    @instance = @klass.new
    @instance.foo = 7
    @instance.instance_variable_get("@foo").should == 7
  end
end

describe Object, "'s lazy_attr_accessor" do
  before :each do
    @klass = Class.new
  end
  
  it "should create a new lazy_attr_reader" do
    @klass.should_receive(:lazy_attr_reader).with(:arg1, :arg2)
    @klass.lazy_attr_accessor(:arg1, :arg2)
  end

  it "should create a new lazy_attr_writer" do
    @klass.should_receive(:lazy_attr_writer).with(:arg1)
    @klass.lazy_attr_accessor(:arg1)
  end
  
  it "should create a new lazy_attr_reader with the block given" do
    @klass.lazy_attr_accessor(:arg1) { 7 }
    @klass.new.arg1.should == 7
  end
  
end
