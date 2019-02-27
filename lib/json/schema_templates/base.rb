# frozen_string_literal: true

module JSON
  module SchemaTemplates
    class Base
      attr_reader :context

      class << self
        def schema(&block)
          define_method :schema do |**locals|
            context.tap_eval(locals: locals, &block)
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
