module CapybaraSelenium
  module SeleniumServer
    class BaseConfigurator < Server::Configurator
    end

    class RemoteConfigurator < BaseConfigurator
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
        browser_name = capabilities[:browser_name]
        version = capabilities[:version]
        platform = capabilities[:platform]
        "#{browser_name}_#{version}_#{platform}"
      end

      # @return [Hash] The desired capabilities for the browser
      def desired_capabilities
        caps = Selenium::WebDriver::Remote::Capabilities.new
        capabilities.keys.each { |key| caps[key] = capabilities[key] }
        caps
      end
    end
  end
end
