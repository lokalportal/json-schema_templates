module JSON
  module SchemaTemplates
    class Context
      class Builder
        include ::JSON::SchemaBuilder
      end

      include BuilderOverrides

      attr_reader :builder

      def self.wrap(object, &block)
        Context.new(object).yield_self { |c| block ? c.tap_eval(&block) : c }
      end

      def initialize(builder = Builder.new.object(defaults_for(:base_object)))
        @builder = builder
      end

      #----------------------------------------------------------------
      #                     Method Missing Stuff
      #----------------------------------------------------------------

      def method_missing(meth, *args, &block)
        puts "missing: #{meth}"

        if local?(meth)
          locals[meth.to_sym]
        elsif builder.respond_to?(meth)
          builder.public_send(meth, *args, &block)
        else
          super
        end
      end

      def respond_to_missing?(meth, include_private = false)
        local?(meth) || builder.respond_to?(meth, include_private)
      end

      #
      # Evaluates the given block in the context of the wrapper and returns the wrapper itself
      #
      # @param [Hash] locals
      #   Locals which will be made available within the context.
      #   They are automatically available when being used inside a rendered partial
      #
      # @return [Wrapper] self
      #
      def tap_eval(locals: {}, &block)
        tap { |c| with_locals(locals) { c.instance_eval(&block) } }
      end

      private

      def local?(name)
        locals.key?(name.to_sym)
      end

      def locals
        @locals ||= {}
      end

      #
      # Executes the given block with the given locals
      #
      # @param [Hash] locals
      #   Locals to be used inside a partial, similar to what ActionView does
      #
      def with_locals(locals)
        @locals = @locals.tap do
          @locals = locals
          yield
        end
      end

      delegate :wrap, to: 'self.class'
      delegate :as_json, to: :builder
      delegate :defaults_for, to: 'JSON::SchemaTemplates.configuration'
      private :wrap

      def config(name)
        ::JSON::SchemaTemplates.configuration.public_send(name)
      end
    end
  end
end
