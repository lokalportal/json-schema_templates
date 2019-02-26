# frozen_string_literal: true

describe Examples::CustomTypes::Schema, type: :integration do
  include_examples 'schema comparison' do
    let(:expected_schema_definition) do
      proc do
        object do
          string :created_at, format: 'date-time', required: true
        end
      end
    end
  end
end

