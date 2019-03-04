# frozen_string_literal: true

module Examples
  module HelperMethods
    class Schema < ::JSON::SchemaTemplates::Base
      schema do
        array :objects do
          items do
            any_of(%w[foo bar baz].map { |k| an_object(k) })
          end
        end
      end

      def an_object(key)
        object do
          string :name, enum: [key]
        end
      end
    end
  end
end
