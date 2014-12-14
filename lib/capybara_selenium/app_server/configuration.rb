module CapybaraSelenium
  module AppServer
    class BaseConfiguration
      attr_accessor :server_host, :server_port
    end

    class RackConfiguration < BaseConfiguration
      attr_accessor :config_ru_path
    end
  end
end
