require 'rails'
require 'konfigurator'

module Konfigurator
  module Helpers
    module ActionController
      def self.included(base)
        base.send :extend, self
        base.helper_method :settings
      end

      def settings
        Rails.application.settings
      end
    end # ActionController
  end # Helpers
end # Konfigurator

Rails::Application.send     :include, Konfigurator::Simple
ActionController::Base.send :include, Konfigurator::Helpers::ActionController
