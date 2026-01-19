# frozen_string_literal: true

module RuboCop
  module Cop
    module Committee
      # Check if `committee_options` enables deprecated `old_assert_behavior`.
      #
      # @example
      #   # bad
      #   def committee_options
      #     { schema_path: "schema.yaml", old_assert_behavior: true }
      #   end
      #
      #   # good
      #   def committee_options
      #     { schema_path: "schema.yaml", old_assert_behavior: false }
      #   end
      #
      class DeprecatedOldAssertBehavior < Base
        MSG = "Do not enable deprecated `old_assert_behavior` in `committee_options`."

        def on_def(node)
          return unless node.method?(:committee_options)

          node.each_descendant(:pair).each do |pair|
            key, value = *pair
            next unless old_assert_behavior_key?(key)
            next unless value&.true_type?

            add_offense(pair)
          end
        end

        private

        def old_assert_behavior_key?(node)
          return node.value == :old_assert_behavior if node.sym_type?
          return node.value == "old_assert_behavior" if node.str_type?

          false
        end
      end
    end
  end
end
