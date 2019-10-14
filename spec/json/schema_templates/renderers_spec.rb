# frozen_string_literal: true

describe JSON::SchemaTemplates::Renderers do
  describe described_class::PartialExpander do
    include JSON::SchemaDsl
    let(:base_path) { 'examples/partials' }

    around(:each) do |ex|
      config = ::JSON::SchemaTemplates.configuration
      config.base_path =
        config.base_path.tap do
          config.base_path = base_path
          ex.run
        end
    end

    let(:input) do
      object do
        partial 'users/user'
      end
    end
    subject(:result) { described_class.new(self).visit(input.to_h).as_json }

    describe '#visit' do
      it 'removes the old partial' do
        expect(result['children'].select { |ch| ch['type'] == 'partial' }).to be_empty
      end
    end
  end
end
