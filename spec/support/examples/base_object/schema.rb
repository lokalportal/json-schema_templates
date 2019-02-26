# frozen_string_literal: true

module Examples
  module BaseObject
    class Schema < ::JSON::SchemaTemplates::Base
      schema do
        string :foobar
      end
    end
  end
end
