# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Committee::MultipleSchemaConform, :config do
  it "registers an offense for multiple assertions in the same request block" do
    expect_offense(<<~RUBY)
      it 'returns users' do
        get '/users'
        assert_schema_conform(200)
        ^^^^^^^^^^^^^^^^^^^^^^^^^^ Avoid multiple schema conformance assertions in the same request block.
        assert_response_schema_confirm(200)
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Avoid multiple schema conformance assertions in the same request block.
      end
    RUBY
  end

  it "registers offenses for duplicate assertions in the same request block" do
    expect_offense(<<~RUBY)
      it 'returns users' do
        get '/users'
        assert_schema_conform(200)
        ^^^^^^^^^^^^^^^^^^^^^^^^^^ Avoid multiple schema conformance assertions in the same request block.
        assert_schema_conform(200)
        ^^^^^^^^^^^^^^^^^^^^^^^^^^ Avoid multiple schema conformance assertions in the same request block.
      end
    RUBY
  end

  it "does not register an offense for a single assertion" do
    expect_no_offenses(<<~RUBY)
      it 'returns users' do
        get '/users'
        assert_schema_conform(200)
      end
    RUBY
  end

  it "does not register an offense when assertions are in separate request blocks" do
    expect_no_offenses(<<~RUBY)
      it 'creates and retrieves user' do
        post '/users', params: { name: 'test' }
        assert_schema_conform(201)

        get '/users/1'
        assert_schema_conform(200)
      end
    RUBY
  end

  it "registers an offense for request and response assertions in the same request block" do
    expect_offense(<<~RUBY)
      it 'returns users' do
        get '/users'
        assert_request_schema_confirm
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Avoid multiple schema conformance assertions in the same request block.
        assert_response_schema_confirm(200)
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Avoid multiple schema conformance assertions in the same request block.
      end
    RUBY
  end

  it "registers offenses for all assertion combinations in the same request block" do
    expect_offense(<<~RUBY)
      it 'returns users' do
        get '/users'
        assert_request_schema_confirm
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Avoid multiple schema conformance assertions in the same request block.
        assert_response_schema_confirm(200)
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Avoid multiple schema conformance assertions in the same request block.
        assert_schema_conform(200)
        ^^^^^^^^^^^^^^^^^^^^^^^^^^ Avoid multiple schema conformance assertions in the same request block.
      end
    RUBY
  end

  it "registers an offense for request assertion with schema conform in the same request block" do
    expect_offense(<<~RUBY)
      it 'returns users' do
        get '/users'
        assert_request_schema_confirm
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Avoid multiple schema conformance assertions in the same request block.
        assert_schema_conform(200)
        ^^^^^^^^^^^^^^^^^^^^^^^^^^ Avoid multiple schema conformance assertions in the same request block.
      end
    RUBY
  end

  it "registers an offense for response assertion with schema conform in the same request block" do
    expect_offense(<<~RUBY)
      it 'returns users' do
        get '/users'
        assert_response_schema_confirm(200)
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Avoid multiple schema conformance assertions in the same request block.
        assert_schema_conform(200)
        ^^^^^^^^^^^^^^^^^^^^^^^^^^ Avoid multiple schema conformance assertions in the same request block.
      end
    RUBY
  end
end
