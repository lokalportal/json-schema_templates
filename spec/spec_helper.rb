# frozen_string_literal: true

require 'bundler/setup'
require 'pry'
require 'byebug'
require 'pry-byebug'
require 'json/schema_templates'
require 'rspec/its'

Dir['./spec/support/**/*.rb'].sort.each { |file| require file }

RSpec.configure do |config|
  config.include IntegrationHelper, type: :integration

  #
  # Allows setting configuration values using the :configuration RSpec metadata on
  # examples or contexts to save a `before(:each) {}`.
  #
  # Example:
  #   context 'when something happens', configuration: {additional_attributes_on_objects: false}
  #
  config.around :each, :configuration do |example|
    ::JSON::SchemaTemplates.configuration.type_defaults.clear
    example.metadata[:configuration].each do |config_name, value|
      ::JSON::SchemaTemplates.configuration.public_send("#{config_name}=", value)
    end
    example.run
    ::JSON::SchemaTemplates.configuration.send(:reset!)
  end

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
