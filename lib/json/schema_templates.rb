# frozen_string_literal: true

require 'json/schema_builder'

%w[base additional_types builder_overrides context configuration].each do |file|
  require "json/schema_templates/#{file}"
end

module JSON
  module SchemaTemplates
    class Error < StandardError; end
    class InvalidSchemaMethodError < Error; end
    class InvalidSchemaPathError < Error; end

    def self.configuration
      @configuration ||= Configuration.new
    end

    def self.configure
      yield(configuration)
    end

    #
    # @return [Hash, nil] The requested schema as JSON hash or +nil+ if no such schema could be found
    #
    # @param [String] schema_path
    #   The requested schema relative to the schema base path.
    #
    # @example
    #   Given the schema base path 'schemas':
    #   JSON::SchemaTemplates.json_schema_for('posts/show') #=> ::Schemas::Posts::Show.new.schema.as_json
    #
    def self.json_schema_for(schema_path)
      "/#{configuration.base_path}/#{schema_path}".camelize.safe_constantize&.new&.schema&.as_json
    end
  end
end
