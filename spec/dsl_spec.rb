require File.dirname(__FILE__) + '/spec_helper'

describe "Object configured with Konfigurator::DSL" do 
  subject do
    ConfiguredWithDSL
  end
  
  it_should_behave_like "configured"

  it "responds to #attr_config and #attr_setting" do 
    subject.should respond_to(:attr_config)
    subject.should respond_to(:attr_setting)
  end
  
  it "responds to defined #foo and #bar settings" do 
    subject.should respond_to(:foo)
    subject.should respond_to(:bar)
  end
  
  it "allows to set config option value with DSL-style syntax" do 
    subject.foo :bar
    subject.foo.should == :bar
  end
  
  it "allows for quick access to current environment name" do 
    subject.environment :production
    subject.environment.should == :production
  end
  
  it "allows to load settings from yaml file" do 
    with_conf_file do |fname|
      subject.environment :production
      subject.attr_config :bla
      subject.load_settings(fname)
      
      subject.bla.should be
      subject.foo.should == "bar"
    end
  end
  
  it "allows to define configuration specific for current env" do 
    subject.attr_config :prod, :dev, :bar
    subject.environment :development
    subject.prod false
    subject.configure(:production) { prod true }
    subject.configure(:development) { dev true }
    subject.configure(:development, :production) { bar :foo }
    
    subject.dev.should be
    subject.prod.should_not be
    subject.bar.should == :foo
  end
end
