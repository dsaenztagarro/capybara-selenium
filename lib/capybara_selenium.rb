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
  class << self
    include AppServer
    include SeleniumServer
    attr_reader :driver, :app_server, :selenium_server

    # @param app_server_type [Symbol] The application server type.
    #   Default: :rack
    # @param selenium_server_type [Symbol The selenium server type.
    #   Default: :remote
    def configure(app_server_type = :rack, selenium_server_type = :remote)
      @app_server = configurator :app_server, app_server_type
      @selenium_server = configurator :selenium_server, selenium_server_type
      yield self
      app_server.apply
      selenium_server.apply
    end

    private

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
