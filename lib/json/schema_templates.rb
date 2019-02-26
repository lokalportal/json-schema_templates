# frozen_string_literal: true

require 'json/schema_builder'

%w[base builder_overrides context].each do |file|
  require "json/schema_templates/#{file}"
end

module JSON
  module SchemaTemplates
    class Error < StandardError; end

    class << self
      attr_accessor :configuration

      def configure
        self.configuration ||= Configuration.new
        yield(configuration)
      end
    end
  end
end
