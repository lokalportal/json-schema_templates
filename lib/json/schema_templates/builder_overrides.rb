module JSON
  module SchemaTemplates
    module BuilderOverrides
      def object(name = nil, additional_properties: false, partial: nil, locals: {}, **options, &block)
        obj = builder.object(name, options.merge(additional_properties: additional_properties))

        if partial
          ::JSON::SchemaTemplates::Base.partial_class(partial).new(wrap(obj)).partial(locals)
        else
          wrap(obj, &block)
        end
      end

      def datetime(name, **options)
        builder.string name, format: 'date-time', **options
      end
    end
  end
end
