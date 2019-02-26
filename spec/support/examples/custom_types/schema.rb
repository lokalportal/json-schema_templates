# frozen_string_literal: true

module Examples
  module CustomTypes
    class Schema < ::JSON::SchemaTemplates::Base
      schema do
        datetime :created_at, required: true
      end
    end
  end
end
