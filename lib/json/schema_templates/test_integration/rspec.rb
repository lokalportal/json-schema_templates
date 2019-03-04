# frozen_string_literal: true

require 'rspec/expectations'

#
# Custom matcher to validate a JSON response against a defined schema in RSpec
#
# The matcher takes the path to a JSON schema and validates the given JSON against it using
# #fully_validate.
#
# Example:
#   expect(my_response_json_as_hash).to validate_against_schema('api/posts/show')
#
module JSON
  module SchemaTemplates
    module TestIntegration
      module Rspec
        extend ::RSpec::Matchers::DSL

        matcher :validate_against_schema do |schema_path|
          match do |response_json|
            @errors = []

            schema = JSON::SchemaTemplates.schema_for(schema_path)

            unless schema
              @errors << "The schema `#{schema_path}` does not exist."
              next false
            end

            @errors = schema.fully_validate(response_json.to_h)
            @errors.empty?
          end

          failure_message do
            @errors.join("\n")
          end
        end
      end
    end
  end
end
