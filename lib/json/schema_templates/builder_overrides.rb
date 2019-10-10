# frozen_string_literal: true

module JSON
  module SchemaTemplates
    module BuilderOverrides
      def array(name = nil, **options, &block)
        wrap(builder.array(name, options), &block)
      end

      #
      # @param [Array] tuple_definitions
      #   if given, the generated schema will contain tuple definitions for the surrounding array,
      #   meaning that the first element in the array has to match the first schema, the second one the
      #   second schema etc.
      #
      def items(tuple_definitions = nil, **options, &block)
        # Unfortunately, we have to override quite a bit of internal functionality here
        # as JSON::SchemaBuilder::Array#items doesn't actually return said items and just sets them internally.
        # See https://github.com/parrish/json-schema_builder/blob/master/lib/json/schema_builder/array.rb#L16
        if tuple_definitions
          builder.items(tuple_definitions)
        else
          builder.items items_entity(**options, &block)
        end
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

      private

      #
      # Generates a new entity to be used inside `#items`.
      # This overrides the corresponding method in JSON::SchemaBuilder
      #
      # @params [String, Symbol] type
      #   Optional type information for the new entity.
      #   If not given, the type is automatically inferred from the actual content
      #
      def items_entity(type: nil, **opts, &block)
        return send(type, opts, &block) if type

        entity(nil, opts, &block)
      end
    end
  end
end
