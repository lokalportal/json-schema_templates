# frozen_string_literal: true

module JSON
  module SchemaTemplates
    class Resolver
      attr_reader :base_path
      def initialize(base_path = nil)
        @base_path = base_path || root_path
      end

      def resolve(name)
        partial_class(name)
      end

      private

      #
      # @return [Boolean] +true+ if the current schema is at least one module level deeper than the root module
      #
      # @example
      #   # base_path: 'schemas'
      #   base_path_nested? # => false
      #
      #   # base_path: 'schemas/users'
      #   base_path_nested? # => true
      #
      def base_path_nested?
        base_path.include?('/')
      end

      #
      # Determines the paths that should be looked into to find the requested partial.
      # The paths will always include the base path as well as the current path,
      # but in case of an already nested path, will also try to infer a sub-directory based
      # on the partial's name similar to ActionView.
      #
      # @example Inferring a sub-directory based on the partial name
      #   # base_path: schemas/users/show
      #   partial_search_paths('attachment')
      #   # => ['schemas/attachments', 'schemas/users', 'schemas']
      #
      def partial_search_paths(requested_partial)
        [].tap do |paths|
          if base_path_nested?
            paths << "#{base_path.split('/')[0..-2].join('/')}/#{requested_partial.pluralize}"
          end

          paths << base_path
          paths << root_path
        end.uniq
      end

      def root_path
        ::JSON::SchemaTemplates.configuration.base_path
      end

      #
      # @param [String] requested_partial
      #   The path to the partial as a slash separated string (e.g. 'users/user')
      #   The method will search for the partial in the same directory as the calling template
      #   as well as based on the root path
      #
      # @return [::JSON::SchemaTemplates::Base]
      # @raise [JSON::SchemaTemplates::InvalidSchemaPathError] No partial with the given name could be found
      #
      def partial_class(requested_partial)
        partial_search_paths(requested_partial).each do |path|
          mod = "/#{path}/#{requested_partial}".camelize.safe_constantize
          return mod if mod
        end

        fail InvalidSchemaPathError,
             "The partial #{requested_partial.inspect} could not found." \
             "Search paths were: #{partial_search_paths(requested_partial).inspect}"
      end
    end
  end
end
