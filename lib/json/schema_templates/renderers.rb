# frozen_string_literal: true

module JSON
  module SchemaTemplates
    module Renderers
      class PartialExpander < JSON::SchemaDsl::Renderers::Base
        def visit(entity)
          traverse(expand_partials(entity))
        end

        def expand_partials(entity)
          return entity unless entity[:children].present?

          partials = entity[:children].select { |ch| ch[:type] == 'partial' }
          return entity if partials.empty?

          contexts = partials.map { |p| Context.new(p, scope) }
          new_children = contexts.flat_map do |con|
            self.class.new(con).visit(con.run.to_h)[:children]
          end
          entity[:children].reject! { |ch| ch[:type] == 'partial' }.push(*new_children)
          entity
        end
      end
    end
  end
end
