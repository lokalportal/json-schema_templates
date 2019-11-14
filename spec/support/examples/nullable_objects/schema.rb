# frozen_string_literal: true

#
# See corresponding spec on why this is commented out.
#

module Examples
  module NullableObjects
    class Schema < ::JSON::SchemaTemplates::Base
      schema do
        object :foo, required: true do
          object :bar, null: true, required: true do
            string :baz
          end
        end
      end
    end
  end
end
