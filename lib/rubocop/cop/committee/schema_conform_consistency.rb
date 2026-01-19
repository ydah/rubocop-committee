# frozen_string_literal: true

module RuboCop
  module Cop
    module Committee
      # Prefer `assert_schema_conform` when request and response schema confirmations
      # are both asserted in the same example.
      #
      # @example EnforcedStyle: combined (default)
      #   # bad
      #   it 'returns users' do
      #     get '/users'
      #     assert_request_schema_confirm
      #     assert_response_schema_confirm(200)
      #   end
      #
      #   # good
      #   it 'returns users' do
      #     get '/users'
      #     assert_schema_conform(200)
      #   end
      #
      # @example EnforcedStyle: separate
      #   # bad
      #   it 'returns users' do
      #     get '/users'
      #     assert_schema_conform(200)
      #   end
      #
      #   # good
      #   it 'returns users' do
      #     get '/users'
      #     assert_request_schema_confirm
      #     assert_response_schema_confirm(200)
      #   end
      #
      class SchemaConformConsistency < Base
        include ConfigurableEnforcedStyle

        MSG_COMBINED = "Use `assert_schema_conform` instead of separate request/response confirmations."
        MSG_SEPARATE = "Use separate `assert_*_schema_confirm` calls instead of `assert_schema_conform`."

        REQUEST_METHOD = :assert_request_schema_confirm
        RESPONSE_METHOD = :assert_response_schema_confirm
        SCHEMA_METHOD = :assert_schema_conform

        EXAMPLE_METHODS = %i[it specify example scenario].freeze
        RESTRICT_ON_SEND = [REQUEST_METHOD, RESPONSE_METHOD, SCHEMA_METHOD].freeze

        def on_send(node) # rubocop:disable InternalAffairs/OnSendWithoutOnCSend
          example_block = example_block_for(node)
          return unless example_block

          return unless offense?(node, example_block)

          add_offense(node, message: offense_message(node))
        end

        private

        def offense?(node, example_block)
          return request_or_response?(node) && request_and_response_in?(example_block) if style == :combined
          return schema_conform?(node) if style == :separate

          false
        end

        def offense_message(_node)
          if style == :combined
            MSG_COMBINED
          elsif style == :separate
            MSG_SEPARATE
          else
            # :nocov:
            :noop
            # :nocov:
          end
        end

        def example_block_for(node)
          node.each_ancestor(:block).find { |ancestor| example_block?(ancestor) }
        end

        def example_block?(node)
          return false unless node.block_type?

          send_node = node.send_node
          return false unless send_node&.send_type?

          EXAMPLE_METHODS.include?(send_node.method_name)
        end

        def request_and_response_in?(example_block)
          has_request = false
          has_response = false

          example_block.each_descendant(:send).each do |send_node|
            next unless send_node.receiver.nil?

            has_request ||= send_node.method?(REQUEST_METHOD)
            has_response ||= send_node.method?(RESPONSE_METHOD)
            return true if has_request && has_response
          end

          false
        end

        def request_or_response?(node)
          node.receiver.nil? && [REQUEST_METHOD, RESPONSE_METHOD].include?(node.method_name)
        end

        def schema_conform?(node)
          node.receiver.nil? && node.method?(SCHEMA_METHOD)
        end
      end
    end
  end
end
