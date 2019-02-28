# frozen_string_literal: true

module JSON
  module SchemaTemplates
    class Base
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
            context.tap_eval(locals: default_locals.merge(locals), &block)
          end
        end
      end

      def initialize(context = Context.new)
        @context = context
        @context.current_path = self.class.to_s.deconstantize.underscore
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
