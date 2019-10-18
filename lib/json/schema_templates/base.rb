# frozen_string_literal: true

module JSON
  module SchemaTemplates
    #
    # Class to hold dsl definitions to be evaluated by contexts.
    #
    class Base
      include JSON::SchemaDsl
      attr_reader :context

      class << self
        #
        # Defines a new JSON schema
        #
        # @return [JSON::SchemaDsl::Builder] The resulting builder structure from the schema.
        # @param [Hash] default_locals
        #   Can be used to define default locals to be available within the schema definition.
        #   Any value given here is automatically overridden by a local passed in through a `partial` call
        #   or a corresponding object call with `partial: 'something'`
        #
        def schema(**default_locals, &block)
          define_method :schema do |**locals|
            context.context_eval(locals: default_locals.merge(locals), &block)
          end
        end
      end
      #
      # @!method schema(**locals)
      #   @param [Hash] locals The locals applied to this schema.
      #   @see Types::Locals
      #   @return [Hash] The resulting ast from the definition evaluated
      #     in this schemas context.

      #
      # @param [Context] context The context which will be used to evaluate the definition from
      #   #schema. Defaults to a root context that is supplied with the self_partial of this schema
      #   and is initialized in root mode.
      #
      def initialize(context = Context.new(self_partial, self, root: true))
        @context = context
      end

      #
      # @return [Hash] A partial node that represents this current schema.
      # @see Types::Partial
      #
      def self_partial
        {name: path.split('/').last, type: 'partial', current_dir: dirname}
      end

      #
      # @return [String] The module path up to the module that contains this schema's class
      #
      def dirname
        self.class.to_s.deconstantize.underscore
      end

      #
      # @return [String] The module path of this schema, including the schema class itself
      #
      def path
        self.class.to_s.underscore
      end
    end
  end
end
