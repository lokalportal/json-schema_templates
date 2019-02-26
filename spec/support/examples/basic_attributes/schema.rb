module Examples
  module BasicAttributes
    class Schema < ::JSON::SchemaTemplates::Base
      schema do
        object :data do
          string :title
          string :body
        end
      end
    end
  end
end
