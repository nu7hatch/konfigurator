require "yaml"

module Konfigurator
  # Available configuration types...
  autoload :DSL,    "konfigurator/dsl"
  autoload :Simple, "konfigurator/simple"

  def self.included(base) # :nodoc:
    # v0.0.1 compatibility...
    base.send(:include, Konfigurator::Simple)
  end

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
