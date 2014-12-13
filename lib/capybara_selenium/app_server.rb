module CapybaraSelenium
  # Responsible for generating an application server object that applies the
  # configuration needed
  module AppServer
    # Base Class for applying to Capybara the configuration of an App Server
    class BaseConfigurator
      attr_accessor :server_host, :server_port, :app_type

      def initialize(opts = {})
        @server_host = opts[:host] || 'localhost'
        @server_port = opts[:port] || 5000
        @app_type = opts[:type] || :rack
        @opts = opts
      end

      def apply
        Capybara.server_host = @server_host
        Capybara.server_port = @server_port
        Capybara.app_host = "http://#{@server_host}:#{@server_port}"
      end
    end

    # Class responsible for applying to Capybara the configuration of a Rack
    # Web Application
    class RackAppConfigurator < BaseConfigurator
      def apply
        super
        path = @opts[:config_ru_path]
        fail 'Invalid config.ru file path' unless File.exist? path
        # require 'pry'
        # binding.pry
        Capybara.app = Rack::Builder.parse_file(path).first
      end
    end

    def app_server_configurator(opts)
      ('CapybaraSelenium::AppServer::' \
       "#{ActiveSupport::Inflector.classify(opts[:type])}AppConfigurator")
        .constantize.new(opts)
    end
  end
end
