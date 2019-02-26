# frozen_string_literal: true

describe Examples::BasicTypes::Schema, type: :integration do
  include_examples 'schema comparison' do
    let(:expected_schema_definition) do
      proc do
        object do
          string :title, min_length: 5, required: true
          string :body, null: true
        end
      end
    end
  end
end
