# frozen_string_literal: true

module JSON
  module SchemaTemplates
    class Context
      class Builder
        include ::JSON::SchemaBuilder
      end

      include AdditionalTypes
      include BuilderOverrides

      attr_reader :builder
      attr_accessor :current_schema

      #
      # Wraps the given JSON::SchemaBuilder entity in a new context
      # Any given options are directly forwarded to the newly created context
      #
      def self.wrap(object, **options, &block)
        Context.new(object, **options).yield_self { |c| block ? c.tap_eval(&block) : c }
      end

      def initialize(builder = Builder.new.object(defaults_for(:base_object)), current_schema: nil)
        @builder = builder
        @current_schema = current_schema
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

      def method_missing(meth, *args, &block)
        if local?(meth)
          locals[meth.to_sym]
        elsif builder.respond_to?(meth)
          builder.public_send(meth, *args, &block)
        elsif helper_method?(meth)
          instance_exec(*args, &current_schema.method(meth).to_proc)
        else
          super
        end
      end

      def respond_to_missing?(meth, include_private = false)
        local?(meth) || builder.respond_to?(meth, include_private)
      end

      private

      def current_path
        current_schema.dirname
      end

      #
      # @return [Boolean] +true+ if the current schema is at least one module level deeper than the root module
      #
      # @example
      #   # current_path: 'schemas'
      #   current_path_nested? # => false
      #
      #   # current_path: 'schemas/users'
      #   current_path_nested? # => true
      #
      def current_path_nested?
        current_path.include?('/')
      end

      #
      # Determines the paths that should be looked into to find the requested partial.
      # The paths will always include the base path as well as the current path,
      # but in case of an already nested path, will also try to infer a sub-directory based
      # on the partial's name similar to ActionView.
      #
      # @example Inferring a sub-directory based on the partial name
      #   # current_path: schemas/users/show
      #   partial_search_paths('attachment')
      #   # => ['schemas/attachments', 'schemas/users', 'schemas']
      #
      def partial_search_paths(requested_partial)
        [].tap do |paths|
          if current_path_nested?
            paths << "#{current_path.split('/')[0..-2].join('/')}/#{requested_partial.pluralize}"
          end

          paths << current_path
          paths << config(:base_path)
        end.uniq
      end

      #
      # @param [String] requested_partial
      #   The path to the partial as a slash separated string (e.g. 'users/user')
      #   The method will search for the partial in the same directory as the calling template
      #   as well as based on the root path
      #
      # @return [::JSON::SchemaTemplates::Base]
      # @raise [JSON::SchemaTemplates::InvalidSchemaPathError] No partial with the given name could be found
      #
      def partial_class(requested_partial)
        partial_search_paths(requested_partial).each do |path|
          mod = "/#{path}/#{requested_partial}".camelize.safe_constantize
          return mod if mod
        end

        fail InvalidSchemaPathError,
             "The partial #{requested_partial.inspect} could not found." \
             "Search paths were: #{partial_search_paths(requested_partial).inspect}"
      end

      def local?(name)
        locals.key?(name.to_sym)
      end

      def locals
        @locals ||= {}
      end

      def helper_method?(meth)
        current_schema.respond_to?(meth)
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

      delegate :as_json, to: :builder
      delegate :defaults_for, to: 'JSON::SchemaTemplates.configuration'

      #
      # Wraps the given JSON::SchemaBuilder entity in a new context
      # Not a direct delegation to Context.wrap as we need access to the current path
      # to forward it to the new context
      #
      def wrap(object, &block)
        self.class.wrap(object, current_schema: current_schema, &block)
      end

      #
      # Shortcut to get a certain configuration value
      #
      def config(name)
        ::JSON::SchemaTemplates.configuration.public_send(name)
      end
    end
  end
end
