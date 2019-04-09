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
    # @return [JSON::SchemaTemplates::Context, nil] the requested schema or +nil+ if it couldn't be found.
    #
    # @param [String] schema_path
    #   The requested schema relative to the schema base path.
    #
    # @example
    #   Given the schema base path 'schemas':
    #   JSON::SchemaTemplates.json_schema_for('posts/show') #=> ::Schemas::Posts::Show.new.schema
    #
    def self.schema_for(schema_path)
      full_path = "/#{configuration.base_path}/#{schema_path}"
      full_path.camelize.safe_constantize&.new&.schema
    end

    #
    # @return [Hash, nil] The requested schema as JSON hash or +nil+ if no such schema could be found
    #
    # @param [String] schema_path
    #   The requested schema relative to the schema base path.
    #
    # @see #schema_for for more information
    #
    def self.json_schema_for(schema_path)
      @schema_cache ||= {}
      return @schema_cache[schema_path] if configuration.cache_schemas && @schema_cache.key?(schema_path)

      @schema_cache[schema_path] = schema_for(schema_path)&.as_json.yield_self do |schema|
        next nil unless schema

        {
          id:        "#{configuration.schema_id_prefix}/#{schema_path}",
          '$schema': 'http://json-schema.org/draft-04/schema#'
        }.merge(schema)
      end
    end
  end
end
