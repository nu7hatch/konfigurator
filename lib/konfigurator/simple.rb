# Konfigurator::Simple is a configuration toolkit strongly inspired by Sinatra 
# framework settings. Thanks to it you can easy implement configuration options 
# to your apps, modules or classes. Take a look at simple example. 
#
#   class MyClass do 
#     set :foo, "bar"
#     enable :bar
#     disable :bla
#
#     configure :production do
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
module Konfigurator 
  module Simple
    def self.included(base) # :nodoc:
      base.send(:include, Common::InstanceMethods)
      base.send(:extend, Common::ClassMethods)
      base.send(:extend, ClassMethods)
    end
    
    module ClassMethods
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
      
      # It loads settings from given <tt>.yml</tt> file. File should have structure
      # like this one:
      #
      #   development:
      #     foo: bar
      #     bar: true
      #   production: 
      #     bla: foobar
      def load_settings(fname, use_envs=true)
        conf = YAML.load_file(fname)
        if use_envs
          conf[env.to_s].each {|k,v| set k.to_sym, v }
        else
          conf.each {|k,v| set k.to_sym, v }
        end
      end
    end # ClassMethods
  end # Simple
end # Konfigurator
