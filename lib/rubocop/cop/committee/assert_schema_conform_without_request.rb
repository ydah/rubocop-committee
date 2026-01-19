# frozen_string_literal: true

module RuboCop
  module Cop
    module Committee
      # Check if `assert_*_schema_conform` is called without making an HTTP request.
      #
      # @example
      #   # bad
      #   it 'conforms to schema' do
      #     assert_schema_conform(200)
      #   end
      #
      #   # good
      #   it 'conforms to schema' do
      #     get '/users'
      #     assert_schema_conform(200)
      #   end
      #
      class AssertSchemaConformWithoutRequest < Base
        MSG = "Call an HTTP request method before asserting schema conformance."

        ASSERT_METHODS = %i[
          assert_schema_conform
          assert_request_schema_confirm
          assert_response_schema_confirm
        ].freeze
        EXAMPLE_METHODS = %i[it specify example scenario].freeze
        EXAMPLE_GROUP_METHODS = %i[describe context feature].freeze
        SUBJECT_METHODS = %i[subject subject!].freeze
        BEFORE_HOOK_METHODS = %i[before].freeze

        RESTRICT_ON_SEND = ASSERT_METHODS

        def on_send(node) # rubocop:disable InternalAffairs/OnSendWithoutOnCSend
          example_block = example_block_for(node)
          return unless example_block
          return if request_in_example_block?(example_block)
          return if request_in_subject?(example_block)
          return if request_in_before_hook?(example_block)

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

        def request_in_example_block?(example_block)
          example_block.each_descendant(:send).any? { |send_node| request_method?(send_node) }
        end

        def request_in_subject?(example_block)
          return false unless subject_called?(example_block)

          example_group_blocks(example_block).any? do |group_block|
            group_block.each_descendant(:block).any? do |block|
              subject_definition_with_request?(block)
            end
          end
        end

        def request_in_before_hook?(example_block)
          example_group_blocks(example_block).any? do |group_block|
            group_block.each_descendant(:block).any? do |block|
              before_hook_with_request?(block)
            end
          end
        end

        def subject_called?(example_block)
          example_block.each_descendant(:send).any? do |send_node|
            send_node.receiver.nil? && SUBJECT_METHODS.include?(send_node.method_name)
          end
        end

        def subject_definition_with_request?(block)
          send_node = block.send_node
          return false unless send_node&.send_type?
          return false unless SUBJECT_METHODS.include?(send_node.method_name)

          block.each_descendant(:send).any? { |send_node| request_method?(send_node) }
        end

        def before_hook_with_request?(block)
          send_node = block.send_node
          return false unless send_node&.send_type?
          return false unless BEFORE_HOOK_METHODS.include?(send_node.method_name)

          block.each_descendant(:send).any? { |send_node| request_method?(send_node) }
        end

        def example_group_blocks(example_block)
          example_block.each_ancestor(:block).select { |ancestor| example_group_block?(ancestor) }
        end

        def example_group_block?(node)
          send_node = node.send_node
          return false unless send_node&.send_type?

          EXAMPLE_GROUP_METHODS.include?(send_node.method_name)
        end

        def request_method?(send_node)
          ::RuboCop::Committee::RequestMethod.call?(send_node)
        end
      end
    end
  end
end
