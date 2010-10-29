require "helper"

class TestSimple < Test::Unit::TestCase
  describe "Konfigurator::Simple" do 
    def subject
      ConfiguredWithSimple
    end
    
    instance_eval COMMON_TESTS
    
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
      subject.configure(:production) { enable :prod }
      subject.configure(:development) { enable :dev }
      subject.configure(:development, :production) { set :bar, :foo }
      assert subject.dev
      assert !subject.prod
      assert_equal :foo, subject.bar
    end
    
    should "allow to load settings from yaml file" do 
      with_conf_file do |fname|
        subject.set :environment, :production
        subject.load_settings(fname)
        assert subject.bla
        assert_equal "bar", subject.foo
      end
    end
    
    should "not use envs when use_envs is false" do
      with_conf_file do |fname|
        subject.set :environment, :production
        subject.load_settings(fname, false)
        assert subject.production
        assert_equal "bar", subject.production['foo']
      end
    end
  end
  
  describe "Object configured with Konfigurator::Simple" do 
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
end
