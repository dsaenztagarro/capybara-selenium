require_relative 'capybara_selenium/version'
require_relative 'capybara_selenium/server/configurator'
require_relative 'capybara_selenium/app_server/configurator'
require_relative 'capybara_selenium/app_server/configuration'
require_relative 'capybara_selenium/selenium_server/configurator'
require_relative 'capybara_selenium/selenium_server/configuration'

require 'active_support/inflector'

# Helpers for initializing selenium drivers
module CapybaraSelenium
  # Class for configuring capybara and selenium in order to instance the
  # desired driver.
  class Configurator
    include AppServer
    include SeleniumServer
    attr_reader :driver

    def initialize(&block)
      define_singleton_method(:dispatch, block) if block_given?
    end

    def apply
      @app_server.apply
      @driver = @selenium_server.apply
    end

    def method_missing(method, *args, &block)
      if method =~ /(.*)_app_server/
        @app_server ||= configurator :app_server, $1
      elsif method =~ /(.*)_selenium_server/
        @selenium_server ||= configurator :selenium_server, $1
      else
        raise
      end
    end

    private

    def configurator(server_type, configurator_type, &block)
      klass = self.class
      server_module = klass.classify(server_type)
      configurator_klass = klass.classify(configurator_type)
      "CapybaraSelenium::#{server_module}::#{configurator_klass}Configurator"
        .constantize.new(configuration(server_module, configurator_klass))
    end

    def configuration(server_module, klass)
      "CapybaraSelenium::#{server_module}::#{klass}Configuration"
        .constantize.new
    end

    def self.classify(type)
      ActiveSupport::Inflector.classify(type)
    end
  end
end
