module CapybaraSelenium
  # Module for applying to Capybara configuration for Selenium Server
  module SeleniumServer
    # Class for applying to Capybara configuration for Selenium Server
    class BaseConfigurator
      attr_accessor :browser_name

      def initialize(opts = {})
        @browser_name = opts[:capabilities][:browser_name] || 'firefox'
        @capabilities = opts[:capabilities] || {}
      end

      private

      # @return [] The desired capabilities for the browser
      def desired_capabilities
        return @desired_capabilities if @desired_capabilities
        @desired_capabilities = Selenium::WebDriver::Remote::Capabilities
                                .send(browser_name)
        # @capabilities.keys.each do |key|
        #   @desired_capabilities.send "#{key}=", @capabilities[key]
        # end
      end

      def default_capabilities
        {
          version: 'ANY',
          platform: 'ANY'
        }
      end

      def method_missing(method)
        capability = desired_capabilities[method]
        return capability if capability
        fail
      end
    end

    # Applies Capybara specific configuration for selenium remote server
    class SeleniumRemoteConfigurator < BaseConfigurator
      attr_accessor :server_url

      def initialize(opts)
        super
        @server_url = opts[:server_url] || 'http://127.0.0.1:4444/wd/hub'
      end

      def apply
        Capybara.current_driver = driver_name
        Capybara.javascript_driver = driver_name
        Capybara.register_driver(driver_name) do |app|
          Capybara::Selenium::Driver.new(
            app,
            browser: :remote,
            url: server_url,
            desired_capabilities: desired_capabilities)
        end
      end

      def driver_name
        "#{browser_name}_#{version}_#{platform}"
      end
    end

    def selenium_server_configurator(opts)
      ('CapybaraSelenium::SeleniumServer::' \
       "Selenium#{ActiveSupport::Inflector.classify(opts[:type])}Configurator")
        .constantize.new(opts)
    end
  end
end
