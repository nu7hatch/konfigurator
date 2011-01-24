require File.dirname(__FILE__) + '/spec_helper'

describe "Konfigurator::Simple" do 
  subject do
    ConfiguredWithSimple
  end
  
  it_should_behave_like "configured"
  
  it "responds to #set" do 
    subject.should respond_to(:set)
  end
  
  it "responds to #enable" do
    subject.should respond_to(:enable)
  end
  
  it "responds to #disable" do 
    subject.should respond_to(:disable)
  end
  
  it "allows to set given option" do 
    subject.set(:foo, "bar").should == "bar"
    subject.settings[:foo].should == "bar"
  end
  
  it "allows to quick disable given option" do 
    subject.disable(:foo).should_not be
    subject.foo.should_not be
  end 
  
  it "allows to quick enable given option" do 
    subject.enable(:foo).should be
    subject.foo.should be
  end
  
  it "allows for quick access to current environment name" do 
    subject.set :environment, :production
    subject.environment.should == :production
  end
  
  it "allows to define configuration specific for current env" do 
    subject.set :environment, :development
    subject.disable :prod
    subject.configure(:production) { enable :prod }
    subject.configure(:development) { enable :dev }
    subject.configure(:development, :production) { set :bar, :foo }
    
    subject.dev.should be
    subject.prod.should_not be
    subject.bar.should == :foo
  end
  
  it "allows to load settings from yaml file" do 
    with_conf_file do |fname|
      subject.set :environment, :production
      subject.load_settings(fname)

      subject.bla.should be
      subject.foo.should == "bar"
    end
  end
  
  it "not uses envs when use_envs is false" do
    with_conf_file do |fname|
      subject.set :environment, :production
      subject.load_settings(fname, false)

      subject.production.should be_kind_of(Hash)
      subject.production['foo'].should == "bar"
    end
  end
end

describe "Object configured with Konfigurator::Simple" do 
  subject do
    ConfiguredWithSimple  
  end
  
  it "responds to #settings and #config" do 
    @configured = subject.new
    @configured.should respond_to(:settings)
    @configured.should respond_to(:config)
  end
  
  it "#settings works properly" do 
    subject.set(:fooo, :bar)
    @configured = subject.new
    @configured.settings.fooo.should == :bar
  end 
end
