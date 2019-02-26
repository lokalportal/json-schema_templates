# frozen_string_literal: true

module JSON
  module SchemaTemplates
    class Configuration
      attr_accessor :additional_properties_on_objects
      attr_accessor :additional_properties_on_base_object

      def initialize
        self.additional_properties_on_objects = false
        self.additional_properties_on_base_object = false
      end
    end
  end
end
