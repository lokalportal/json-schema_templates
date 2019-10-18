# frozen_string_literal: true

module JSON
  module SchemaTemplates
    #
    # The execution context of a partial.
    # Given a partial node, it uses a resolver to find the partial_class and executes that
    # classes partial definition with itself as the scope. This allows the application of locals
    # as well as further delegation to the calling scope of the context.
    #
    class Context
      include JSON::SchemaDsl

      attr_reader :current_partial, :scope
      #
      # @param [Hash] current_partial The partial node that should be expanded.
      # @param [Object] scope The calling scope that constructed the tree containing the
      #   given partial node.
      # @param [Boolean] root Whether or not this context is executing the definition of
      #   a schema at its root. This only happens when schemas are initialized directly and the
      #   expansion is not initiated by the {Renderers::PartialExpander}. If `true` the context will apply
      #   a special set of defaults for the base_object.
      #
      def initialize(current_partial, scope, root: false)
        @current_partial = current_partial
        @scope           = scope
        @root            = root
      end

      #
      # Evaluates the given block in this context and returns the resulting ast.
      #
      # @param [Hash] locals
      #   Locals which will be made available within the context.
      #   They are automatically available when being used inside a rendered partial
      #
      # @return [Hash] The ast generated from the evaluation of the schema partial.
      #
      def context_eval(locals: {}, &block)
        defaults = @root ?  defaults_for(:base_object) : {}
        with_locals(locals) { instance_eval { object(**defaults, scope: self, &block) } }
      end

      #
      # Evaluates the schemas schema using the saved locals.
      # @return [Hash] The schema definition as an ast.
      #
      def run
        schema.schema(**locals)
      end

      #
      # Delegates missing methods first to locals and then to the given scope.
      #
      def method_missing(meth, *args, &block)
        if local?(meth)
          locals[meth.to_sym]
        elsif helper_method?(meth)
          scope.send(meth, *args, &block)
        else
          super
        end
      end

      #
      # `true` if a local with that name is available, `super` otherwise.
      #
      def respond_to?(meth, priv = false)
        local?(meth) || super
      end

      #
      # `true` if a local with that name is available or the scope responds to this method.
      #
      def respond_to_missing?(meth, include_private = false)
        local?(meth) || scope.respond_to?(meth, include_private)
      end

      #
      # @return [JSON::SchemaTemplates::Base] The schema fitting the current
      #   partials name or path attribute, found by the resolver.
      #   The schema will be initialized with this context as its context.
      #
      def schema
        @schema ||= resolver.resolve(current_partial[:name] || current_partial[:name]).new(self)
      end

      #
      # If a schema is available, it will supply the dirname, otherwise the current_partials will be
      # used. Note that currently the `current_dir` attribute on the partial is only used if this
      # context is executed in root mode or the user supplied it explicitly when creating the partial
      # ast. Used to initialize this contexts resolver.
      # @return [String] The name of the current directory.
      #
      def dirname
        @schema&.dirname || current_partial[:current_dir]
      end

      #
      # @return [Resolver] The context specific resolver used to find the partial class.
      #
      def resolver
        @resolver ||= Resolver.new(scope.try(:dirname) || current_partial[:current_dir])
      end

      private

      #
      # @param [#to_sym] name The name of the possible local value.
      # @return [Boolean] `true` if a local with that name is specified, `false` otherwise.
      #
      def local?(name)
        locals.key?(name.to_sym)
      end

      #
      # @return [Hash] The locals of this context, supplied by the `current_partial`.
      # @see #initialize
      #
      def locals
        @locals ||= current_partial[:locals].to_h
      end

      #
      # @return [Boolean] `true` if the scope responds to the given method.
      # @see #method_missing
      #
      def helper_method?(meth)
        scope.respond_to?(meth)
      end

      #
      # Executes the given block with the given locals set to this contexts locals.
      #
      # @param [Hash] locals
      #   Locals to be used inside a partial, similar to what ActionView does it.
      # @return [Hash] the resulting ast from the evaluation.
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
