# frozen_string_literal: true

require 'json/schema_builder'

%w[base builder_overrides context].each do |file|
  require "json/schema_templates/#{file}"
end

module JSON
  module SchemaTemplates
    class Error < StandardError; end
  end
end
