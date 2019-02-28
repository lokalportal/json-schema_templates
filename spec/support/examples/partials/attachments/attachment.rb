# frozen_string_literal: true

module Examples
  module Partials
    module Attachments
      class Attachment < ::JSON::SchemaTemplates::Base
        schema do
          string :url
          partial 'shared/timestamps', locals: {mandatory: false} # overrides the default local values
        end
      end
    end
  end
end
