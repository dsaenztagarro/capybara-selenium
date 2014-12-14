module CapybaraSelenium
  module Server
    class Configurator
      def initialize(configuration)
        @configuration = configuration
      end

      def configure(&block)
        @configuration = create_configuration
        block.call @configuration
      end

      def create_configuration
        fail 'Abstract method should be implemented by subclasses'
      end

      def method_missing(method)
        if @configuration.respond_to? method
          return @configuration.send(method)
        else
          raise
        end
      end
    end
  end
end
