# frozen_string_literal: true

module Examples
  module Partials
    module Admin
      module Users
        class User < ::JSON::SchemaTemplates::Base
          schema do
            email :email
            datetime :birthday
          end
        end
      end
    end
  end
end
