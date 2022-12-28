# frozen_string_literal: true

require_relative "rubocop/committee/inject"
require_relative "rubocop/committee/version"

require_relative "rubocop/cop/committee/expected_response_status_code"
require_relative "rubocop/cop/committee/redundant_response_status_assertions"

module RuboCop
  module Committee
    PROJECT_ROOT = ::Pathname.new(__dir__).parent.expand_path.freeze
    CONFIG_DEFAULT = PROJECT_ROOT.join("config", "default.yml").freeze
    CONFIG = ::YAML.safe_load(CONFIG_DEFAULT.read).freeze
    private_constant(:CONFIG_DEFAULT, :PROJECT_ROOT)
  end
end

RuboCop::Committee::Inject.defaults!
