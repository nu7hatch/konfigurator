require "yaml"

# Konfigurator is a configuration toolkit strongly inspired by Sinatra framework
# settings. Thanks to it you can easy implement configuration options to your apps, 
# modules or classes. Take a look at simple example. 
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
module Konfigurator
  module Common
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
      
      # Returns hash with defined configuration options. 
      def settings
        @settings ||= {}
      end
      alias :config :settings
      
      # It returns name of current environment.
      def environment
        settings[:environment] ||= settings[:env] || ENV["APP_ENV"] || :development
      end
      alias :env :environment
    end # ClassMethods
  end # Common
end # Konfigurator
