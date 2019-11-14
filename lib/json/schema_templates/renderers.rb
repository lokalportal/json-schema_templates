# frozen_string_literal: true

module JSON
  module SchemaTemplates
    module Renderers
      #
      # Renderer that takes partials and locals to expand them into sub-trees for the given
      #   ast node.
      #
      class PartialExpander < JSON::SchemaDsl::Renderers::Base
        #
        # @return [Hash] The ast node but with all partial and locals nodes replaced
        #   by the generated ast from said partials.
        # @param [Hash] entity The ast node that should be visited to expand its partials.
        #
        def visit(entity)
          traverse(expand_partials(entity))
        end

        private

        #
        # Exands all partial nodes in this node.
        # @param [Hash] entity The entity node that is currently being visited.
        # @return [Hash] The same entity but with children from the partials added.
        #
        def expand_partials(entity)
          return entity unless entity[:children].present?

          entity.merge(
            children: entity[:children]
                      .push(*extract_partials(entity).flat_map { |p| expand_partial(p) })
                      .reject { |ch| %w[locals partial].include?(ch[:type].to_s) }
          )
        end

        #
        # Takes any locals-nodes and combines them with partial nodes.
        # @param [Hash] entity The entity node that is currently being visited.
        # @return [Array<Hash>] An array of partial hashes.
        #
        def extract_partials(entity)
          entity[:children]
            .group_by { |ch| ch[:type].to_s }
            .values_at('partial', 'locals')
            .map(&:to_a)
            .reduce(:zip)
            .map do |(partial, local)|
            partial.merge(locals: local) { |_, old, new| old.merge(new.to_h) }
          end
        end

        # @param [Hash] partial A partial node converted to a hash.
        #
        # @return [Array<Hash>] An array of new nodes rendered in the partial.
        #
        def expand_partial(partial)
          con = Context.new(partial, scope)
          self.class.new(con).visit(con.run.to_h)[:children]
        end
      end

      ::JSON::SchemaDsl.registered_renderers.prepend(PartialExpander)
    end
  end
end
