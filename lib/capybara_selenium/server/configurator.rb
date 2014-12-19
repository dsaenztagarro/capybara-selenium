module CapybaraSelenium
  module Server
    class Configurator
      attr_accessor :config

      def initialize(config)
        @config = config
      end

      def configure(&block)
        @config = create_config
        block.call @config
      end

      def method_missing(method, *args, &_)
        if @config.respond_to? method
          if method =~ /(.*)=/
            return @config.send method, args.first
          else
            return @config.send method
          end
        else
          fail
        end
      end

      private

      def create_config
        *modules, klass = self.class.to_s.split('::')
        "#{modules.join('::')}::#{type_of klass}Configuration".constantize.new
      end

      def type_of(klass)
        /^(?<type>(.*))Configurator/.match(klass)[:type]
      end
    end
  end
end
