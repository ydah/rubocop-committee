# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Committee::RedundantResponseStatusAssertions, :config do
  it "registers an offense and autocorrects when using `assert_schema_conform` " \
     "with argument and `have_http_status`" do
    expect_offense(<<~RUBY)
      it 'something' do
        subject
        expect(response).to have_http_status(400)
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Remove redundant HTTP response status code validation.
        do_something
        assert_schema_conform(400)
      end
    RUBY

    expect_correction(<<~RUBY)
      it 'something' do
        subject
        do_something
        assert_schema_conform(400)
      end
    RUBY
  end

  it "registers an offense and autocorrects when using `assert_response_schema_confirm` " \
     "with argument and `have_http_status`" do
    expect_offense(<<~RUBY)
      it 'something' do
        subject
        expect(response).to have_http_status 400
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Remove redundant HTTP response status code validation.
        do_something
        assert_response_schema_confirm 400
      end
    RUBY

    expect_correction(<<~RUBY)
      it 'something' do
        subject
        do_something
        assert_response_schema_confirm 400
      end
    RUBY
  end

  it "does not register an offense when using `assert_schema_conform` " \
     "with no argument and `have_http_status`" do
    expect_no_offenses(<<~RUBY)
      it 'something' do
        subject
        do_something
        expect(response).to have_http_status(400)
        assert_schema_conform
      end
    RUBY
  end
end
