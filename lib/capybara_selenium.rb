require 'capybara_selenium/version'
require 'capybara_selenium/app_server'
require 'capybara_selenium/selenium_server'

require 'active_support/inflector'

# Helpers for initializing selenium drivers
module CapybaraSelenium
  # Class for configuring capybara and selenium in order to instance the
  # desired driver.
  class GlobalConfigurator
    include AppServer
    include SeleniumServer

    def initialize(opts = {})
      check_options(opts)
      @app_server = configurator_for :app_server, opts
      @selenium_server = configurator_for :selenium_server, opts
    end

    def driver
      @app_server.apply
      @selenium_server.apply
    end

    private

    def check_options(opts)
      fail 'App Server config missing' unless opts[:app_server]
      fail 'Selenium Server config missing' unless opts[:selenium_server]
    end

    def configurator_for(*args)
      configurator_type = args.shift
      opts = args.first[configurator_type]
      send "#{configurator_type}_configurator", opts
    end
  end
end
