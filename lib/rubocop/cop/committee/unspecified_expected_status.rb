# frozen_string_literal: true

module RuboCop
  module Cop
    module Committee
      # Check if the status code is specified as an argument to the method of the Committee
      # where the expected response status code is required.
      #
      # @example
      #   # bad
      #   it 'something' do
      #     subject
      #     assert_schema_conform
      #   end
      #
      #   # good
      #   it 'something' do
      #     subject
      #     assert_schema_conform(200)
      #   end
      #
      class UnspecifiedExpectedStatus < Base
        include RangeHelp
        extend AutoCorrector

        MSG = "Specify the HTTP status code of the expected response as an argument."
        RESTRICT_ON_SEND = %i[assert_schema_conform assert_response_schema_confirm].freeze

        # @!method have_http_status(node)
        def_node_search :have_http_status, <<~PATTERN
          (send nil? :have_http_status (:int $_))
        PATTERN

        def on_send(node)
          return if node.arguments?

          have_http_status(node.parent) do |status|
            return autocorrect(node, status)
          end

          add_offense(node)
        end

        private

        def autocorrect(node, status)
          add_offense(node) do |corrector|
            corrector.insert_after(node, "(#{status})")
          end
        end
      end
    end
  end
end
