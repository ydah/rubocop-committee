# frozen_string_literal: true

require "rubocop"

require_relative "rubocop/committee/version"
require_relative "rubocop/committee/plugin"

require_relative "rubocop/cop/committee/assert_schema_conform_without_request"
require_relative "rubocop/cop/committee/redundant_response_status_assertions"
require_relative "rubocop/cop/committee/unspecified_expected_status"
