# frozen_string_literal: true

require "lint_roller"

module RuboCop
  module Committee
    # A plugin that integrates RuboCop Committee with RuboCop's plugin system.
    class Plugin < LintRoller::Plugin
      def about
        LintRoller::About.new(
          name: "rubocop-committee",
          version: Version::STRING,
          homepage: "https://github.com/ydah/rubocop-committee",
          description: "Committee-specific analysis for your projects, as an extension to RuboCop."
        )
      end

      def supported?(context)
        context.engine == :rubocop
      end

      def rules(_context)
        project_root = Pathname.new(__dir__).join("../../..")

        LintRoller::Rules.new(type: :path, config_format: :rubocop, value: project_root.join("config", "default.yml"))
      end
    end
  end
end
