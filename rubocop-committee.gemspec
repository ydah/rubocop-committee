# frozen_string_literal: true

require_relative "lib/rubocop/committee/version"

Gem::Specification.new do |spec|
  spec.name = "rubocop-committee"
  spec.version = Rubocop::Committee::VERSION
  spec.authors = ["ydah"]
  spec.email = ["t.yudai92@gmail.com"]

  spec.summary = "Automatic committee code style checking tool."
  spec.description = <<~DESCRIPTION
    Automatic committee code style checking tool.
    A RuboCop extension focused on enforcing committee.
  DESCRIPTION
  spec.homepage = "https://github.com/ydah/rubocop-committee"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/releases"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "rubocop"
  spec.metadata["rubygems_mfa_required"] = "true"
end
