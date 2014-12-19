module CapybaraSelenium
  module AppServer
    class BaseConfigurator < Server::Configurator
      def apply
        Capybara.server_host = host
        Capybara.server_port = port
        Capybara.app_host = url
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
