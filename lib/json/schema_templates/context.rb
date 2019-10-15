# frozen_string_literal: true

module JSON
  module SchemaTemplates
    class Context
      include JSON::SchemaDsl

      attr_reader :current_partial, :scope
      def initialize(current_partial, scope, root: false)
        @current_partial = current_partial
        @scope           = scope
        @root            = root
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
      def context_eval(locals: {}, &block)
        defaults = @root ?  defaults_for(:base_object) : {}
        with_locals(locals) { instance_eval { object(**defaults, scope: self, &block) } }
      end

      def run
        schema.schema(**locals)
      end

      def method_missing(meth, *args, &block)
        if local?(meth)
          locals[meth.to_sym]
        elsif helper_method?(meth)
          scope.send(meth, *args, &block)
        else
          super
        end
      end

      def respond_to?(meth, priv = false)
        local?(meth) || super
      end

      def respond_to_missing?(meth, include_private = false)
        local?(meth) || scope.respond_to?(meth, include_private)
      end

      def schema
        @schema ||= resolver.resolve(current_partial[:name] || current_partial[:name]).new(self)
      end

      def dirname
        @schema&.dirname || current_partial[:current_dir]
      end

      def resolver
        @resolver ||= Resolver.new(scope.try(:dirname) || current_partial[:current_dir])
      end

      private

      def local?(name)
        locals.key?(name.to_sym)
      end

      def locals
        @locals ||= current_partial[:locals].to_h
      end

      def helper_method?(meth)
        scope.respond_to?(meth)
      end

      #
      # Executes the given block with the given locals
      #
      # @param [Hash] locals
      #   Locals to be used inside a partial, similar to what ActionView does
      #
      def with_locals(locals)
        result = nil
        @locals = @locals.tap do
          @locals = locals
          result = yield
        end
        result
      end
      delegate :defaults_for, to: 'JSON::SchemaTemplates.configuration'

      #
      # Shortcut to get a certain configuration value
      #
      def config(name)
        ::JSON::SchemaTemplates.configuration.public_send(name)
      end
    end
  end
end
