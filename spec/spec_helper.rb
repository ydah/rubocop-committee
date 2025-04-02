# frozen_string_literal: true

require "rubocop-committee"
require "rubocop/rspec/support"

require "simplecov" unless ENV["NO_COVERAGE"]

module SpecHelper
  ROOT = Pathname.new(__dir__).parent.freeze
end

RSpec.configure do |config|
  config.order = :random
  config.disable_monkey_patching!
  config.raise_errors_for_deprecations!
  config.raise_on_warning = true
end
