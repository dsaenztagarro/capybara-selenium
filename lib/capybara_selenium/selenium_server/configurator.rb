module CapybaraSelenium
  module SeleniumServer
    class BaseConfigurator < Server::Configurator
      private

      def caps(key)
        capabilities[key]
      end
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
        "#{caps[:browser_name]}_#{caps[:version]}_#{caps[:platform]}"
      end

      # @return [] The desired capabilities for the browser
      def desired_capabilities
        return @desired_capabilities if @desired_capabilities
        @desired_capabilities = Selenium::WebDriver::Remote::Capabilities
                                .send(caps[:browser_name])
      end
    end
  end
end
