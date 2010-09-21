require "helper"

class Configured
  include Konfigurator
end

class TestKonfigurator < Test::Unit::TestCase
  describe "Configured class" do 
    should "respond to #set" do 
      assert Configured.respond_to?(:set)
    end
    
    should "respond to #enable" do
      assert Configured.respond_to?(:enable)
    end
    
    should "respond to #disable" do 
      assert Configured.respond_to?(:disable)
    end
    
    should "respond to #environment and #env" do 
      assert Configured.respond_to?(:environment)
      assert Configured.respond_to?(:env)
    end
    
    should "respond to #settings and #config" do 
      assert Configured.respond_to?(:settings)
      assert Configured.respond_to?(:config)
    end
    
    should "respond to #configure" do 
      assert Configured.respond_to?(:configure)
    end
    
    should "allow to set given option" do 
      assert_equal "bar", Configured.set(:foo, "bar")
      assert_equal "bar", Configured.settings[:foo]
    end
    
    should "allow to quick disable given option" do 
      assert !Configured.disable(:foo)
      assert !Configured.foo
    end 
    
    should "allow to quick enable given option" do 
      assert Configured.enable(:foo)
      assert Configured.foo
    end
    
    should "allow for quick access to current environment name" do 
      Configured.set :environment, :production
      assert_equal :production, Configured.environment
    end
    
    should "allow to define configuration specific for current env" do 
      Configured.set :environment, :development
      Configured.disable :prod
      Configured.configure :production do 
        enable :prod
      end
      Configured.configure :development do 
        enable :dev
      end
      Configured.configure :development, :production do
        set :bar, :foo
      end
      assert Configured.dev
      assert !Configured.prod
      assert_equal :foo, Configured.bar
    end
    
    should "allow to load settings from yaml file" do 
      Configured.set :environment, :production
      Configured.load_settings(File.dirname(__FILE__)+"/conf.yml")
      assert Configured.bla
      assert_equal "bar", Configured.foo
    end
  end
  
  describe "Configured object" do 
    setup do 
      @configured = Configured.new
    end
    
    should "respond to #settings and #config" do 
      assert @configured.respond_to?(:settings)
      assert @configured.respond_to?(:config)
    end
    
    should "#settings works properly" do 
      Configured.set(:fooo, :bar)
      @configured = Configured.new
      assert_equal :bar, @configured.settings.fooo
    end 
  end
end
