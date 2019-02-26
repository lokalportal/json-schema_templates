# frozen_string_literal: true

require 'json/schema_builder'

%w[base builder_overrides context configuration].each do |file|
  require "json/schema_templates/#{file}"
end

module JSON
  module SchemaTemplates
    class Error < StandardError; end

    def self.configuration
      @configuration ||= Configuration.new
    end

    def self.configure
      yield(configuration)
    end
  end
end
