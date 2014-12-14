module CapybaraSelenium
  module SeleniumServer
    class BaseConfiguration
      attr_accessor :capabilities
    end

    class RemoteConfiguration < BaseConfiguration
      attr_accessor :server_url
    end
  end
end
