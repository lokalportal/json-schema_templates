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
      attr_accessor :current_path

      def self.wrap(object, **options, &block)
        Context.new(object, **options).yield_self { |c| block ? c.tap_eval(&block) : c }
      end

      def initialize(builder = Builder.new.object(defaults_for(:base_object)), current_path: nil)
        @builder = builder
        @current_path = current_path
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

      def current_path_nested?
        current_path.include?('/')
      end

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
      #
      def partial_class(requested_partial)
        partial_search_paths(requested_partial).each do |path|
          mod = "/#{path}/#{requested_partial}".camelize.safe_constantize
          return mod if mod
        end

        fail InvalidSchemaPathError, "The partial #{requested_partial.inspect} could not found"
      end

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

      delegate :as_json, to: :builder
      delegate :defaults_for, to: 'JSON::SchemaTemplates.configuration'

      def wrap(object, &block)
        self.class.wrap(object, current_path: current_path, &block)
      end

      def config(name)
        ::JSON::SchemaTemplates.configuration.public_send(name)
      end
    end
  end
end
