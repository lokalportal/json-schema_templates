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

      # Builder that is specifically defined to build the untyped locals node.
      class LocalsBuilder < JSON::SchemaDsl::Builder
        def method_missing(meth, *args, &block)
          set(meth, *args, &block) || super
        end

        def respond_to_missing?(*)
          true
        end

        def self.inner_class
          Locals
        end
      end

      # Untyped locals node that can hold any information and
      # is combined with partial nodes when evaluating the partial.
      class Locals
        include ::JSON::SchemaDsl::AstNode

        def initialize(attributes)
          @attributes = attributes
        end

        def attributes
          @attributes ||= {}
        end
        alias to_h attributes
        alias to_hash to_h

        # dummy
        def self.has_attribute?(_name) # rubocop:disable Naming/PredicateName
          true
        end

        # dummy
        def self.schema
          {}
        end

        def self.builder
          LocalsBuilder
        end
      end
      JSON::SchemaDsl.register_type(Locals)

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
