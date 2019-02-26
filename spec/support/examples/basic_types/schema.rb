module Examples
  module BasicTypes
    class Schema < ::JSON::SchemaTemplates::Base
      schema do
        string :title, min_length: 5, required: true
        string :body, null: true
      end
    end
  end
end
