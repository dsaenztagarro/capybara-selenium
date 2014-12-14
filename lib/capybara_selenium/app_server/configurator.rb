module CapybaraSelenium
  module AppServer
    class BaseConfigurator < Server::Configurator
      def apply
        Capybara.server_host = server_host
        Capybara.server_port = server_port
        Capybara.app_host = "http://#{server_host}:#{server_port}"
      end

      private

      def create_configuration
        "CapybaraSelenium::AppServer::#{app_server_type}Configuration"
          .constantize.new
      end

      def app_server_type
        /^(?<type>(.)*)Configurator/.match(self.class)[:type]
      end
    end

    # Class responsible for applying to Capybara the configuration of a Rack
    # Web Application
    class RackConfigurator < BaseConfigurator
      def apply
        super
        fail 'Invalid config.ru file path' unless File.exist? config_ru_path
        Capybara.app = Rack::Builder.parse_file(config_ru_path).first
      end
    end
  end
end
