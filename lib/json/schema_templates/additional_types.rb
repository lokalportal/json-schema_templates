# frozen_string_literal: true

module JSON
  module SchemaTemplates
    module AdditionalTypes
      def datetime(name, **options)
        builder.string name, format: 'date-time', **options
      end

      def email(name, **options)
        builder.string name, format: 'email', **options
      end

      #
      # Renders the partial with the given name inside the current template
      #
      # @example
      #   object :foo do
      #     string :name
      #     partial 'shared/timestamps'
      #   end
      #
      #   This will result in adding the fields defined in 'Shared::Timestamps' on the same level as `:name`
      #
      def partial(partial_path, locals: {})
        # By passing ourselves to the partial, it will override our current path
        # with its own path. Therefore, we have to reset it to its original value
        # after the partial was rendered.
        self.current_schema = current_schema.tap do
          partial_class(partial_path).new(self).schema(locals)
        end
      end
    end
  end
end
