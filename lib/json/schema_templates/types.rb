# frozen_string_literal: true

module JSON
  module SchemaTemplates
    module Types
      T = JSON::SchemaDsl::Types

      class Email < JSON::SchemaDsl::String
        def self.infer_type
          'string'
        end

        def self.type_method_name
          'email'
        end

        attribute(:format, T::String.default('email'))
      end
      JSON::SchemaDsl.register_type(Email)

      class DateTime < JSON::SchemaDsl::String
        def self.infer_type
          'string'
        end

        def self.type_method_name
          'datetime'
        end

        attribute(:format, T::String.default('date-time'))
      end
      JSON::SchemaDsl.register_type(DateTime)

      class Partial < JSON::SchemaDsl::Entity
        def self.type_method_name
          'partial'
        end

        attribute?(:current_dir, T::String)
        attribute?(:path, T::String)
        attribute?(:locals, T::Hash)
      end
      JSON::SchemaDsl.register_type(Partial)
    end
  end
end
