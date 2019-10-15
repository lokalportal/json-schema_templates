# frozen_string_literal: true

module JSON
  module SchemaTemplates
    class Base
      include JSON::SchemaDsl
      attr_reader :context

      class << self
        #
        # Defines a new JSON schema
        #
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

      def initialize(context = Context.new(self_partial, self, root: true))
        @context = context
      end

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
