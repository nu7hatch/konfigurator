require "yaml"

# Configurator is a configuration toolkit strongly ispired by Sinatra's settings. 
# Thanks to it you can easy implement configuration options to your app, module
# or class. Take a look at simple example. 
#
#   class MyClass do 
#     set :foo, "bar"
#     enable :bar
#     disable :bla
#
#     configure :production
#       enable :bla
#       set :spam, "eggs!"
#     end
#   end
#
# Now you can get configured options directly from your class:
#
#   MyClass.foo # => "bar"
#   MyClass.bar # => true
#   MyClass.bla # => false
#
# ... or when current environment is set to <tt>:production</tt>:
#
#   MyClass.bla  # => true
#   MyClass.spam # => "eggs!"
#
# All settings are also available from objects via <tt>#settings</tt> method:
#
#   obj = MyObject.new
#   obj.settings.foo # => "bar"
#   obk.settings.bar # => true
#
# <b>Remember!</b> when option is not set then <tt>NoMethodError</tt> will be
# raised after try to get it direcly from class, eg:
#
#   MyObject.set :exist
#   MyObject.exist      # => true
#   MyObject.not_exist  # => will raise NoMethodError
module Configurator

  def self.included(base) # :nodoc:
    base.send(:extend, ClassMethods)
    base.send(:include, InstanceMethods)
  end
  
  module InstanceMethods
    # Access to configuration options is defined in the class methods, so it's
    # only syntactic sugar for <tt>self.class</tt>.
    def settings
      self.class
    end
    alias :config :settings
  end # InstanceMethods
  
  module ClassMethods
    # Run once, at startup, in any environment. To add an option use the 
    # <tt>set</tt> method (For boolean values You can use <tt>#enable</tt> and 
    # <tt>#disable</tt> methods):
    # 
    #   configure do
    #     set :foo, 'bar'
    #     enable :bar
    #     disable :yadayada
    #   end
    #   
    # Run only when the environment (or the <tt>APP_ENV</tt> env variable)is set 
    # to <tt>:production</tt>:
    # 
    #   configure :production do
    #     ...
    #   end
    #
    # Run when the environment is set to either <tt>:production</tt> or <tt>:test</tt>:
    # 
    #   configure :production, :test do
    #     ...
    #   end
    def configure(*envs, &block)
      class_eval(&block) if envs.empty? || envs.include?(env.to_sym)   
    end
    
    # It loads settings from given <tt>.yml</tt> file. File should have structure
    # like this one:
    #
    #   development:
    #     foo: bar
    #     bar: true
    #   production: 
    #     bla: foobar
    def load_settings(fname)
      conf = YAML.load_file(fname)
      conf[env.to_s].each {|k,v| set k.to_sym, v }
    end

    # Returns hash with defined configuration options. 
    def settings
      @settings ||= {}
    end
    alias :config :settings
    
    # It "enables" given setting. It means that it assigns <tt>true</tt> value
    # to the specified setting key.
    #
    #   enable :foo # => set :foo, true
    def enable(name)
      set(name, true)
    end

    # It "disables" given setting. It means that it assigns <tt>false</tt> value
    # to the specified setting key.
    #
    #   disable :foo # => set :foo, false
    def disable(name)
      set(name, false)
    end
    
    # Assigns given value to the specified setting key. 
    #
    #   set :foo, "YadaYadaYaday!"
    #   set :bae, true
    #
    # See also shortcuts for boolean settings: <tt>#enable</tt> and 
    # <tt>#disable</tt> methods. 
    def set(name, value)
      name = name.to_sym
      unless self.respond_to?(name)
        meta = class << self; self; end
        meta.send(:define_method, name) { settings[name] }
      end 
      settings[name] = value
    end
    
    # It returns name of current environment.
    def environment
      settings[:environment] ||= settings[:env] || ENV["APP_ENV"] || :development
    end
    alias :env :environment
  end # ClassMethods
end # Configurator
