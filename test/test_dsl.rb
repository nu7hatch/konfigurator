require "helper"

class TestDSL < Test::Unit::TestCase
  describe "Object configured with Konfigurator::DSL" do 
    def subject
      ConfiguredWithDSL
    end
    
    instance_eval COMMON_TESTS
  
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
      with_conf_file do |fname|
        subject.environment :production
        subject.attr_config :bla
        subject.load_settings(fname)
        assert subject.bla
        assert_equal "bar", subject.foo
      end
    end
    
    should "allow to define configuration specific for current env" do 
      subject.attr_config :prod, :dev, :bar
      subject.environment :development
      subject.prod false
      subject.configure(:production) { prod true }
      subject.configure(:development) { dev true }
      subject.configure(:development, :production) { bar :foo }
      assert subject.dev
      assert !subject.prod
      assert_equal :foo, subject.bar
    end
  end
end
