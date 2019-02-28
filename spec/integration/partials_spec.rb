# frozen_string_literal: true

describe Examples::Partials::Admin::Users::Show,
         type: :integration,
         configuration: {additional_properties_on_objects: false,
                         additional_properties_on_base_object: false,
                         base_path: 'examples/partials'} do
  include_examples 'schema comparison' do
    let(:expected_schema_definition) do
      proc do
        object additional_properties: false do
          object :data, additional_properties: false do
            object :private_data, additional_properties: false do
              string :email, format: 'email'
              string :birthday, format: 'date-time'
            end

            object :public_data, additional_properties: false do
              string :name
              object :avatar, additional_properties: false do
                string :url
                string :created_at, required: false, format: 'date-time'
                string :updated_at, required: false, format: 'date-time'
              end

              string :created_at, required: true, format: 'date-time'
              string :updated_at, required: true, format: 'date-time'
            end
          end
        end
      end
    end
  end
end
