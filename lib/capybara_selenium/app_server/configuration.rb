module CapybaraSelenium
  module AppServer
    # Base class for all web application server configurations
    class BaseConfiguration
      attr_accessor :host, :port, :url

      def url
        return "http://#{host}:#{port}" unless @url && !@url.empty?
        @url
      end
    end

    # Configuration for Rack application server
    class RackConfiguration < BaseConfiguration
      attr_accessor :config_ru_path
    end
  end
end
