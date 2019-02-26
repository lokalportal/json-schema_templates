# frozen_string_literal: true

module JSON
  module SchemaTemplates
    class Configuration
      attr_accessor :additional_properties_on_objects

      def initialize
        self.additional_properties_on_objects = false
      end
    end
  end
end
