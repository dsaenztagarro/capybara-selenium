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
    attr_reader :driver, :app_server, :selenium_server

    # @param [Hash] opts The options for configuring servers
    # @option opts [String] :app_server The application server type. Default
    #   :rack
    # @option opts [String] :selenium_server The selenium server type. Default
    #   :remote
    def initialize(opts = {}, &block)
      @app_server = configurator :app_server, app_server_type(opts)
      @selenium_server = configurator :selenium_server, selenium_server_type(opts)
      define_singleton_method :configure do
        block.call(app_server, selenium_server)
        app_server.apply
        selenium_server.apply
      end
    end

    private

    # @param [Hash] opts The options for app server
    # @option opts [Symbol] :app_server The app server type
    # @return [String] The application server type
    def app_server_type(opts)
      opts[:app_server] || :rack
    end

    # @param [Hash] opts The options for selenium server
    # @option opts [Symbol] :selenium_server The selenium server type
    # @return [String] The selenium server type
    def selenium_server_type(opts)
      opts[:selenium_server] || :remote
    end

    def configurator(server_type, configurator_type, &block)
      server_module = server_type.to_s.classify
      configurator_klass = configurator_type.to_s.classify
      "CapybaraSelenium::#{server_module}::#{configurator_klass}Configurator"
        .constantize.new(configuration(server_module, configurator_klass))
    end

    def configuration(server_module, klass)
      "CapybaraSelenium::#{server_module}::#{klass}Configuration"
        .constantize.new
    end
  end
end
