module Konfigurator
  module DSL
    def self.included(base) # :nodoc:
      base.send(:include, Common::InstanceMethods)
      base.send(:extend, Common::ClassMethods)
      base.send(:extend, ClassMethods)
    end
    
    module ClassMethods
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
