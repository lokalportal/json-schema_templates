module JSON
  module SchemaTemplates
    class Base
      class << self
        def schema(&block)
          define_method :schema do
            context.tap_eval(&block)
          end
        end

        def partial(&block)
          define_method :partial do |**locals|
            context.tap_eval(locals: locals, &block)
          end
        end

        #
        # @param [String] partial_path
        #   The path to the partial as a slash separated string (similar to #find)
        #
        # @return [Schemas::Base] the schema class for the given partial
        #
        # @example
        #   partial_class('path/to/partial')
        #   #=> Schemas::Partials::Path::To::Partial
        #
        def partial_class(partial_path)
          # Work with Rails' constant discovery (aka #constantize).
          # It's slower, but is more error-proof in development environment...
          "::Schemas::Partials::#{partial_path.to_s.camelize}".constantize
        end
      end

      def context
        @context ||= Context.new
      end

      def method_missing(meth, *args, &block)
        if context.respond_to?(meth)
          context.public_send(meth, *args, &block)
        else
          super
        end
      end

      def respond_to_missing?(meth, include_private = false)
        context.respond_to?(meth, include_private)
      end
    end
  end
end
