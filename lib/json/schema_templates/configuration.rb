# frozen_string_literal: true

module JSON
  module SchemaTemplates
    class Configuration
      attr_accessor :additional_properties_on_objects
      attr_accessor :additional_properties_on_base_object

      def initialize
        reset!
      end

      def defaults_for(subject)
        defaults[subject.to_sym]
      end

      #
      # Resets the configuration back to its default values
      #
      def reset!
        self.additional_properties_on_objects = nil
        self.additional_properties_on_base_object = nil
      end

      private

      def defaults
        {
          base_object: {
            additional_properties: additional_properties_on_base_object
          },
          object: {
            additional_properties: additional_properties_on_objects
          }
        }.transform_values(&:compact)
      end
    end
  end
end
