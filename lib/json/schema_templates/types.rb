# frozen_string_literal: true

module JSON
  module SchemaTemplates
    # Additional node-types to be registered with SchemaDsl
    module Types
      T = JSON::SchemaDsl::Types

      # The `email` type that renders to a string node with the format 'email'.
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

      # The `date_time` type that renders to a string with the format 'date-time'
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
        # Since locals can have any attribute, the builder will accept any method
        #   as an attribute setter/getter.
        def method_missing(meth, *args, &block)
          set(meth, *args, &block) || super
        end

        # nodoc
        def respond_to_missing?(*)
          true
        end

        # nodoc
        def self.inner_class
          Locals
        end
      end

      # Untyped locals node that can hold any information and
      # is combined with partial nodes when evaluating the partial.
      class Locals
        include ::JSON::SchemaDsl::AstNode

        # @param [Hash] attributes The locals defined for this node.
        def initialize(attributes)
          @attributes = attributes
        end

        # @return [Hash] The locals that are defined for this node.
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

        # @return [Builder] The builder that is used to build this node.
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
