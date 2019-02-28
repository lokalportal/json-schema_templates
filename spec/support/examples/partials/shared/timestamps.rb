# frozen_string_literal: true

module Examples
  module Partials
    module Shared
      class Timestamps < ::JSON::SchemaTemplates::Base
        schema mandatory: true do # Sets a default value for the "mandatory" local
          datetime :created_at, required: mandatory
          datetime :updated_at, required: mandatory
        end
      end
    end
  end
end
