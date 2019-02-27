# frozen_string_literal: true

module Examples
  module Partials
    module Users
      class User < ::JSON::SchemaTemplates::Base
        schema do
          string :name

          # the more verbose form of `partial: 'attachment'`
          object :avatar do
            partial 'attachment'
          end

          partial 'shared/timestamps', locals: {mandatory: true}
        end
      end
    end
  end
end
