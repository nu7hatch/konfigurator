require "helper"

class ConfiguredWithSimple
  include Konfigurator::Simple
end

class ConfiguredWithDSL
  include Konfigurator::DSL
  attr_config :foo, :bar
end

COMMON_TESTS = lambda do
  should "respond to #environment and #env" do 
    assert subject.respond_to?(:environment)
    assert subject.respond_to?(:env)
  end
  
  should "respond to #settings and #config" do 
    assert subject.respond_to?(:settings)
    assert subject.respond_to?(:config)
  end
  
  should "respond to #configure" do 
    assert subject.respond_to?(:configure)
  end
end

class TestKonfigurator < Test::Unit::TestCase
  describe "Configured class" do 
    def subject
      ConfiguredWithSimple
    end
    
    instance_eval &COMMON_TESTS
    
    should "respond to #set" do 
      assert subject.respond_to?(:set)
    end
    
    should "respond to #enable" do
      assert subject.respond_to?(:enable)
    end
    
    should "respond to #disable" do 
      assert subject.respond_to?(:disable)
    end
    
    should "allow to set given option" do 
      assert_equal "bar", subject.set(:foo, "bar")
      assert_equal "bar", subject.settings[:foo]
    end
    
    should "allow to quick disable given option" do 
      assert !subject.disable(:foo)
      assert !subject.foo
    end 
    
    should "allow to quick enable given option" do 
      assert subject.enable(:foo)
      assert subject.foo
    end
    
    should "allow for quick access to current environment name" do 
      subject.set :environment, :production
      assert_equal :production, subject.environment
    end
    
    should "allow to define configuration specific for current env" do 
      subject.set :environment, :development
      subject.disable :prod
      subject.configure :production do 
        enable :prod
      end
      subject.configure :development do 
        enable :dev
      end
      subject.configure :development, :production do
        set :bar, :foo
      end
      assert subject.dev
      assert !subject.prod
      assert_equal :foo, subject.bar
    end
    
    should "allow to load settings from yaml file" do 
      subject.set :environment, :production
      subject.load_settings(File.dirname(__FILE__)+"/conf.yml")
      assert subject.bla
      assert_equal "bar", subject.foo
    end
  end
  
  describe "Configured object" do 
    def subject
      ConfiguredWithSimple  
    end
    
    setup do 
      @configured = subject.new
    end
    
    should "respond to #settings and #config" do 
      assert @configured.respond_to?(:settings)
      assert @configured.respond_to?(:config)
    end
    
    should "#settings works properly" do 
      subject.set(:fooo, :bar)
      @configured = subject.new
      assert_equal :bar, @configured.settings.fooo
    end 
  end
  
  describe "Configured with DSL class" do 
    def subject
      ConfiguredWithDSL
    end
    
    instance_eval &COMMON_TESTS
  
    should "respond to #attr_config and #attr_setting" do 
      assert subject.respond_to?(:attr_config)
      assert subject.respond_to?(:attr_setting)
    end
    
    should "respond to defined #foo and #bar settings" do 
      assert subject.respond_to?(:foo)
      assert subject.respond_to?(:bar)
    end
    
    should "allow to set config option value with DSL-style syntax" do 
      subject.foo :bar
      assert_equal :bar, subject.foo
    end
    
    should "allow for quick access to current environment name" do 
      subject.environment :production
      assert_equal :production, subject.environment
    end
    
    should "allow to load settings from yaml file" do 
      subject.environment :production
      subject.attr_config :bla
      subject.load_settings(File.dirname(__FILE__)+"/conf.yml")
      assert subject.bla
      assert_equal "bar", subject.foo
    end
    
    should "allow to define configuration specific for current env" do 
      subject.attr_config :prod, :dev, :bar
      
      subject.environment :development
      subject.prod false
      subject.configure :production do 
        prod true
      end
      subject.configure :development do 
        dev true
      end
      subject.configure :development, :production do
        bar :foo
      end
      assert subject.dev
      assert !subject.prod
      assert_equal :foo, subject.bar
    end
  end
end
