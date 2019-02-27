# frozen_string_literal: true

describe ::JSON::SchemaTemplates::Configuration do
  subject { JSON::SchemaTemplates.configuration }

  describe '#root_module' do
    context 'when an invalid base path was given', configuration: {base_path: 'foobar'} do
      it 'raises a corresponding exception' do
        expect { subject.root_module }.to raise_error JSON::SchemaTemplates::InvalidSchemaPathError
      end
    end

    context 'when an existing schema path was given', configuration: {base_path: 'examples/partials'} do
      its(:root_module) { is_expected.to be Examples::Partials }
    end
  end
end
