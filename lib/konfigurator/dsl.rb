# This module provides configuration with nice-looking DSL syntax. It allow you
# to configure your apps/classes such like here:
#
#     Foo.configure do 
#       host "127.0.0.1"
#       port 8080
#       password "secret"
#     end
#
# But what's important in this kind of configuration, you have to define all possible
# options first. You can define configuration attributes easy using <tt>#attr_config</tt> 
# (or <tt>#attr_setting</tt> alias). 
#
#    class Foo 
#      include Konfigurator::DSL
#
#      attr_config :host, :port
#      attr_config :password
#    end
#
# Other use cases behave almost the same as with Konfigurator::Simple:
#
#    Foo.host # => "127.0.0.1"
#    Foo.port # => 8080
#
#    Foo.env :production
#    Foo.configure :production do 
#      host "production.com"
#      port 80
#    end
#
#    foo = Foo.new
#    foo.settings.host # => "production.com"
#    foo.settings.port # => 80
module Konfigurator
  module DSL
    def self.included(base) # :nodoc:
      base.send(:include, Common::InstanceMethods)
      base.send(:extend, Common::ClassMethods)
      base.send(:extend, ClassMethods)
    end
    
    module ClassMethods
      # It defines given configuration attributes.
      #
      #   attr_config :host, :port
      #   attr_config :password
      def attr_config(*attrs)
        attrs.each do |attr|
          self.class.class_eval <<-EVAL 
            def #{attr.to_s}(value=nil)
              settings[#{attr.to_sym.inspect}] = value unless value.nil?
              return settings[#{attr.to_sym.inspect}]
            end
          EVAL
        end
      end
      alias :attr_setting :attr_config
      
      # See Konfigurator#environment for more info.
      def environment(env=nil)
        settings[:environment] = env unless env.nil?
        settings[:environment] ||= settings[:env] || ENV["APP_ENV"] || :development
      end
      alias :env :environment
      
      # See Konfigurator::Simple#load_settings for more info.
      def load_settings(fname)
        conf = YAML.load_file(fname)
        conf[env.to_s].each {|k,v| send(k.to_sym, v) }
      end
    end # ClassMethods
  end # DSL
end # Konfigurator
