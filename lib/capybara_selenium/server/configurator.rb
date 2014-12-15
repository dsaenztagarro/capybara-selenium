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

      def method_missing(method)
        if @configuration.respond_to? method
          return @configuration.send(method)
        else
          raise
        end
      end

      private

      def create_configuration
        *modules, klass = self.class.to_s.split('::')
        "#{modules.join('::')}::#{type_of(klass)}Configuration"
          .constantize.new
      end

      def type_of(klass)
        /^(?<type>(.*))Configurator/.match(klass)[:type]
      end
    end
  end
end
