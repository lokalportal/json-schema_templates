# frozen_string_literal: true

module Examples
  module Entities
    class Schema < ::JSON::SchemaTemplates::Base
      schema do
        entity :something, required: true do
          any_of [
            object { string(:bar) },
            object { string(:baz) }
          ]
        end
      end
    end
  end
end
