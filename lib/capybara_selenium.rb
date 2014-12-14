require_relative 'version'
require_relative 'server/configurator'
require_relative 'app_server/configurator'
require_relative 'app_server/configuration'
require_relative 'selenium_server/configurator'
require_relative 'selenium_server/configuration'

require 'active_support/inflector'

# Helpers for initializing selenium drivers
module CapybaraSelenium
  # Class for configuring capybara and selenium in order to instance the
  # desired driver.
  class Configurator
    include AppServer
    include SeleniumServer

    def initialize(&block)
      check_options(opts)
      @app_server = configurator_for :app_server, opts
      @selenium_server = configurator_for :selenium_server, opts
    end

    def driver
      @app_server.apply
      @selenium_server.apply
    end

    def setup(&block)
      block.call(@app_server)
    end

    def method_missing(method, *args, &block)
      if method =~ /(.)*_app_server/
        @app_server ||= configurator :app_server, $0
      elsif method =~ /(.)*_selenium_server/
        @selenium_server ||= configurator :selenium_server, $0
      else
        raise
      end
    end

    private

    def configurator(server_type, configurator_type)
      klass = self.class
      server_module = klass.classify(server_type)
      configurator_klass = klass.classify(configurator_type)
      "CapybaraSelenium::#{server_module}::#{configurator_klass}Configurator"
        .constantize.new
    end

    def self.classify(type)
      ActiveSupport::Inflector.classify(type)
    end
  end
end
