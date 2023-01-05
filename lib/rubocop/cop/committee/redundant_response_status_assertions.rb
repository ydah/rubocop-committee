# frozen_string_literal: true

module RuboCop
  module Cop
    module Committee
      # Check for validation of redundant response HTTP status codes.
      #
      # @example
      #   # bad
      #   it 'does something' do
      #     subject
      #     expect(response).to have_http_status 400
      #     assert_schema_conform(400)
      #   end
      #
      #   # good
      #   it 'does something' do
      #     subject
      #     assert_schema_conform(400)
      #   end
      #
      class RedundantResponseStatusAssertions < Base
        include RangeHelp
        extend AutoCorrector

        MSG = "Remove redundant HTTP response status code validation."
        RESTRICT_ON_SEND = %i[assert_schema_conform assert_response_schema_confirm].freeze

        # @!method have_http_status(node)
        def_node_search :have_http_status, <<~PATTERN
          $(send nil? :have_http_status (:int _))
        PATTERN

        def on_send(node)
          return if node.first_argument.nil?

          have_http_status(node.parent) do |http_node|
            return autocorrect(node, http_node.parent.loc.expression)
          end
        end

        private

        def autocorrect(_node, bad_range)
          add_offense(bad_range) do |corrector|
            corrector.remove(range_by_whole_lines(bad_range, include_final_newline: true))
          end
        end
      end
    end
  end
end
