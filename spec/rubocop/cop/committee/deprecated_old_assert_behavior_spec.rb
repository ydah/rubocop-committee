# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Committee::DeprecatedOldAssertBehavior, :config do
  it "registers an offense when `old_assert_behavior: true` is set" do
    expect_offense(<<~RUBY)
      def committee_options
        { schema_path: "schema.yaml", old_assert_behavior: true }
                                      ^^^^^^^^^^^^^^^^^^^^^^^^^ Do not enable deprecated `old_assert_behavior` in `committee_options`.
      end
    RUBY
  end

  it "registers an offense when memoized options enable old behavior" do
    expect_offense(<<~RUBY)
      def committee_options
        @committee_options ||= { schema_path: "schema.yaml", old_assert_behavior: true }
                                                             ^^^^^^^^^^^^^^^^^^^^^^^^^ Do not enable deprecated `old_assert_behavior` in `committee_options`.
      end
    RUBY
  end

  it "does not register an offense when `old_assert_behavior` is false" do
    expect_no_offenses(<<~RUBY)
      def committee_options
        { schema_path: "schema.yaml", old_assert_behavior: false }
      end
    RUBY
  end

  it "does not register an offense when `old_assert_behavior` is not present" do
    expect_no_offenses(<<~RUBY)
      def committee_options
        { schema_path: "schema.yaml" }
      end
    RUBY
  end
end
