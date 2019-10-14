# frozen_string_literal: true

module JSON
  module SchemaTemplates
    module Renderers
      class PartialExpander < JSON::SchemaDsl::Renderers::Base
        def visit(entity)
          traverse(expand_partials(entity))
        end

        private

        def expand_partials(entity)
          return entity unless entity[:children].present?

          entity.merge(
            children: entity[:children]
                      .flat_map { |ch| ch[:type] == 'partial' ? expand_partial(ch) : ch }
                      .reject { |ch| ch[:type] == 'partial' }
          )
        end

        def expand_partial(partial)
          con = Context.new(partial, scope)
          self.class.new(con).visit(con.run.to_h)[:children]
        end
      end

      ::JSON::SchemaDsl.registered_renderers.prepend(PartialExpander)
    end
  end
end
