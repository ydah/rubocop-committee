# frozen_string_literal: true

module RuboCop
  module Cop
    module Committee
      # Check for unused schema coverage setup without any report call.
      #
      # @example
      #   # bad
      #   before do
      #     @schema_coverage = Committee::Test::SchemaCoverage.new(schema)
      #     @committee_options[:schema_coverage] = @schema_coverage
      #   end
      #
      #   # good
      #   before do
      #     @schema_coverage = Committee::Test::SchemaCoverage.new(schema)
      #     @committee_options[:schema_coverage] = @schema_coverage
      #   end
      #
      #   after(:all) do
      #     @schema_coverage.report
      #   end
      #
      class UnusedSchemaCoverage < Base
        MSG = "Call `report` or `report_flatten` when schema coverage is set up."

        EXAMPLE_GROUP_METHODS = %i[describe context feature].freeze

        # @!method schema_coverage_assignment(node)
        def_node_search :schema_coverage_assignment, <<~PATTERN
          (ivasgn :@schema_coverage (send (const (const (const nil? :Committee) :Test) :SchemaCoverage) :new ...))
        PATTERN

        # @!method schema_coverage_report?(node)
        def_node_search :schema_coverage_report?, <<~PATTERN
          (send (ivar :@schema_coverage) {:report :report_flatten})
        PATTERN

        def on_block(node)
          return unless example_group?(node)

          assignment = schema_coverage_assignment(node).first
          return unless assignment
          return if schema_coverage_report?(node)

          add_offense(assignment)
        end
        alias on_numblock on_block

        private

        def example_group?(node)
          send_node = node.send_node
          return false unless send_node&.send_type?

          EXAMPLE_GROUP_METHODS.include?(send_node.method_name)
        end
      end
    end
  end
end
