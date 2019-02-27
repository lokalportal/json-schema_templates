# frozen_string_literal: true

module Examples
  module Partials
    module Users
      class User < ::JSON::SchemaTemplates::Base
        schema do
          string :name
          string :avatar_url

          partial 'shared/timestamps', locals: {mandatory: true}
        end
      end
    end
  end
end
