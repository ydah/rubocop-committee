# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Committee::AssertSchemaConformWithoutRequest, :config do
  it "registers an offense when using `assert_schema_conform` without a request" do
    expect_offense(<<~RUBY)
      it 'conforms to schema' do
        assert_schema_conform(200)
        ^^^^^^^^^^^^^^^^^^^^^^^^^^ Call an HTTP request method before asserting schema conformance.
      end
    RUBY
  end

  it "registers an offense when using `assert_response_schema_confirm` without a request" do
    expect_offense(<<~RUBY)
      it 'conforms to schema' do
        assert_response_schema_confirm(200)
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Call an HTTP request method before asserting schema conformance.
      end
    RUBY
  end

  it "registers an offense when using `assert_request_schema_confirm` without a request" do
    expect_offense(<<~RUBY)
      it 'conforms to schema' do
        assert_request_schema_confirm
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Call an HTTP request method before asserting schema conformance.
      end
    RUBY
  end

  it "does not register an offense when a request is made in the example" do
    expect_no_offenses(<<~RUBY)
      it 'conforms to schema' do
        get '/users'
        assert_schema_conform(200)
      end
    RUBY
  end

  it "does not register an offense when a request is made in subject" do
    expect_no_offenses(<<~RUBY)
      RSpec.describe 'Users API' do
        subject { get '/users' }

        it 'conforms to schema' do
          subject
          assert_schema_conform(200)
        end
      end
    RUBY
  end

  it "does not register an offense when a request is made in a before hook" do
    expect_no_offenses(<<~RUBY)
      RSpec.describe 'Users API' do
        before do
          get '/users'
        end

        it 'conforms to schema' do
          assert_schema_conform(200)
        end
      end
    RUBY
  end
end
