# frozen_string_literal: true

module JSON
  module SchemaTemplates
    class Configuration
      # Sets a default value for `additional_properties` on objects used in schemas
      # Setting it to `nil` results in the key not being present in the resulting schema
      def additional_properties_on_objects=(bool)
        ::JSON::SchemaDsl.add_defaults_for(:object, additional_properties: bool)
      end

      def additional_properties_on_objects
        ::JSON::SchemaDsl.type_defaults.dig(:object, :additional_properties)
      end

      # Every generated schema is wrapped in a root object.
      # This setting controls whether this root object is allowed to have additional properties
      attr_accessor :additional_properties_on_base_object

      # The schema base path.
      # As every schema is a class and part of a module hierarchy, setting it to
      # 'schemas' would mean that all schemas reside nested inside a `Schemas` module, e.g.
      # `Schemas::MySchema`
      attr_accessor :base_path

      # If set to +true+, schemas which were generated once are cached.
      # This speeds up time, especially in tests as JSON::SchemaDsl seems to be quite slow
      # when it comes to re-opening objects.
      attr_accessor :cache_schemas

      # The prefix to be used when generating IDs for JSON schemas,
      # in most cases your application's domain.
      attr_accessor :schema_id_prefix

      def initialize
        reset!
      end

      def defaults_for(subject)
        return defaults[subject.to_sym] if subject.to_sym == :base_object

        ::JSON::SchemaDsl.type_defaults[subject]
      end

      #
      # @return [Module] the root module the application's schemas reside in (based on #base_path)
      #
      def root_module
        "::#{base_path&.camelize}".try(:safe_constantize) ||
            fail(InvalidSchemaPathError, "#{base_path.inspect} is not an existing schema path")
      end

      private

      #
      # Resets the configuration back to its default values
      #
      def reset!
        self.additional_properties_on_objects = nil
        self.additional_properties_on_base_object = nil
        self.base_path = 'schemas'
        self.cache_schemas = false
        self.schema_id_prefix = 'https://example.com'
      end

      def defaults
        {
          base_object: {
            additional_properties: additional_properties_on_base_object
          }
        }.transform_values(&:compact)
      end
    end
  end
end
