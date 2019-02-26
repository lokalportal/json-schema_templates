# frozen_string_literal: true

require 'bundler/setup'
require 'pry'
require 'byebug'
require 'pry-byebug'
require 'json/schema_templates'

Dir['./spec/support/**/*.rb'].sort.each { |file| require file }

RSpec.configure do |config|
  config.include IntegrationHelper, type: :integration

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
