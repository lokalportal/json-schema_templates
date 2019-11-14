# frozen_string_literal: true

#
# this test is set to :pending due to a bug in json-schema_templates that prevents
# the developer from using `null: true` on objects.
# Once this is fixed, the test should be re-enabled.
#
describe Examples::NullableObjects::Schema, type: :integration do
  include_examples 'schema comparison' do
    let(:expected_schema_definition) do
      proc do
        object do
          object :foo, required: true do
            object :bar, null: true, required: true do
              string :baz
            end
          end
        end
      end
    end
  end
end
