# frozen_string_literal: true

module Examples
  module Partials
    module Attachments
      class Attachment < ::JSON::SchemaTemplates::Base
        schema do
          string :url
          datetime :uploaded_at
        end
      end
    end
  end
end
