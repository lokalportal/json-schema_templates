# frozen_string_literal: true

module JSON
  module SchemaTemplates
    module BuilderOverrides
      def array(name = nil, **options, &block)
        wrap(builder.array(name, options), &block)
      end

      def items(**options, &block)
        fail InvalidSchemaMethodError, '#items is only available inside Arrays' unless builder.type == :array

        # Unfortunately, we have to call protected methods here as JSON::SchemaBuilder::Array#items doesn't actually
        # return said items and just sets them internally.
        # See https://github.com/parrish/json-schema_builder/blob/master/lib/json/schema_builder/array.rb#L16
        builder.schema[:items] = wrap(builder.send(:items_entity, options), &block)
        builder.parent.reinitialize
      end

      def object(name = nil, partial: nil, locals: {}, **options, &block)
        builder.object(name, options.reverse_merge(defaults_for(:object))).yield_self do |obj|
          if partial
            partial_class(partial).new(wrap(obj)).schema(locals)
          else
            wrap(obj, &block)
          end
        end
      end

      def entity(name, **options, &block)
        wrap(builder.entity(name, options), &block)
      end
    end
  end
end
