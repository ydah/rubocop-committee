# frozen_string_literal: true

module RuboCop
  module Cop
    module Committee
      # Check for multiple schema conformance assertions within the same request block.
      #
      # @example
      #   # bad
      #   it 'returns users' do
      #     get '/users'
      #     assert_schema_conform(200)
      #     assert_response_schema_confirm(200)
      #   end
      #
      #   # good
      #   it 'returns users' do
      #     get '/users'
      #     assert_schema_conform(200)
      #   end
      #
      class MultipleSchemaConform < Base
        MSG = "Avoid multiple schema conformance assertions in the same request block."

        ASSERT_METHODS = %i[
          assert_schema_conform
          assert_request_schema_confirm
          assert_response_schema_confirm
        ].freeze
        EXAMPLE_METHODS = %i[it specify example scenario].freeze

        RESTRICT_ON_SEND = ASSERT_METHODS

        def on_send(node) # rubocop:disable InternalAffairs/OnSendWithoutOnCSend
          example_block = example_block_for(node)
          return unless example_block

          segments = request_segments(example_block)
          segment = segment_for(node, segments)
          return unless segment

          return if assertion_count(segment) < 2

          add_offense(node)
        end

        private

        def example_block_for(node)
          node.each_ancestor(:block).find { |ancestor| example_block?(ancestor) }
        end

        def example_block?(node)
          return false unless node.block_type?

          send_node = node.send_node
          return false unless send_node&.send_type?

          EXAMPLE_METHODS.include?(send_node.method_name)
        end

        def request_segments(example_block)
          segments = []
          current = []

          example_block.body.each_child_node do |child|
            if request_call?(child)
              segments << current if current.any?
              current = [child]
            else
              current << child
            end
          end

          segments << current if current.any?
          segments
        end

        def request_call?(node)
          return false unless node&.send_type?

          ::RuboCop::Committee::RequestMethod.call?(node)
        end

        def segment_for(node, segments)
          node_range = node.source_range
          segments.find do |segment|
            segment.any? { |child| range_contains?(child.source_range, node_range) }
          end
        end

        def assertion_count(segment)
          segment.sum do |child|
            child.each_descendant(:send).count do |send_node|
              send_node.receiver.nil? && ASSERT_METHODS.include?(send_node.method_name)
            end + (send_in_assert_methods?(child) ? 1 : 0)
          end
        end

        def send_in_assert_methods?(node)
          return false unless node&.send_type?

          node.receiver.nil? && ASSERT_METHODS.include?(node.method_name)
        end

        def range_contains?(outer, inner)
          outer.begin_pos <= inner.begin_pos && outer.end_pos >= inner.end_pos
        end
      end
    end
  end
end
