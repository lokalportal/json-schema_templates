# frozen_string_literal: true

module Examples
  module Partials
    module Admin
      module Users
        class Show < ::JSON::SchemaTemplates::Base
          schema do
            object :data do
              object :private_data, partial: 'user' # will look in the same directory first (admin/users/user)
              object :public_data, partial: 'users/user' # starts at the root path (users/user)
            end
          end
        end
      end
    end
  end
end
