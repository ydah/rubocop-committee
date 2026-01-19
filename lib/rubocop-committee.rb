# frozen_string_literal: true

require "rubocop"

require_relative "rubocop/committee/version"
require_relative "rubocop/committee/plugin"

require_relative "rubocop/committee/request_method"
require_relative "rubocop/cop/committee/assert_schema_conform_without_request"
require_relative "rubocop/cop/committee/deprecated_old_assert_behavior"
require_relative "rubocop/cop/committee/multiple_schema_conform"
require_relative "rubocop/cop/committee/schema_conform_consistency"
require_relative "rubocop/cop/committee/redundant_response_status_assertions"
require_relative "rubocop/cop/committee/unused_schema_coverage"
require_relative "rubocop/cop/committee/unspecified_expected_status"
