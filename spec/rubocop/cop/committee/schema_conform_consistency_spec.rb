# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Committee::SchemaConformConsistency, :config do
  context "when EnforcedStyle is combined" do
    let(:cop_config) { { "EnforcedStyle" => "combined" } }

    it "registers offenses when request and response confirmations are both present" do
      expect_offense(<<~RUBY)
        it 'returns users' do
          get '/users'
          assert_request_schema_confirm
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `assert_schema_conform` instead of separate request/response confirmations.
          assert_response_schema_confirm(200)
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `assert_schema_conform` instead of separate request/response confirmations.
        end
      RUBY
    end

    it "does not register an offense when using assert_schema_conform" do
      expect_no_offenses(<<~RUBY)
        it 'returns users' do
          get '/users'
          assert_schema_conform(200)
        end
      RUBY
    end

    it "does not register an offense when only one confirmation is present" do
      expect_no_offenses(<<~RUBY)
        it 'returns users' do
          get '/users'
          assert_request_schema_confirm
        end
      RUBY
    end
  end

  context "when EnforcedStyle is separate" do
    let(:cop_config) { { "EnforcedStyle" => "separate" } }

    it "registers an offense for assert_schema_conform" do
      expect_offense(<<~RUBY)
        it 'returns users' do
          get '/users'
          assert_schema_conform(200)
          ^^^^^^^^^^^^^^^^^^^^^^^^^^ Use separate `assert_*_schema_confirm` calls instead of `assert_schema_conform`.
        end
      RUBY
    end

    it "does not register an offense when using request and response confirmations" do
      expect_no_offenses(<<~RUBY)
        it 'returns users' do
          get '/users'
          assert_request_schema_confirm
          assert_response_schema_confirm(200)
        end
      RUBY
    end
  end
end
