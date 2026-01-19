# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Committee::UnusedSchemaCoverage, :config do
  it "registers an offense when schema coverage is set up but not reported" do
    expect_offense(<<~RUBY)
      RSpec.describe 'Users API' do
        before do
          @schema_coverage = Committee::Test::SchemaCoverage.new(schema)
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Call `report` or `report_flatten` when schema coverage is set up.
          @committee_options[:schema_coverage] = @schema_coverage
        end

        it 'does something' do
          get '/users'
          assert_schema_conform(200)
        end
      end
    RUBY
  end

  it "does not register an offense when report is called" do
    expect_no_offenses(<<~RUBY)
      RSpec.describe 'Users API' do
        before do
          @schema_coverage = Committee::Test::SchemaCoverage.new(schema)
          @committee_options[:schema_coverage] = @schema_coverage
        end

        after(:all) do
          @schema_coverage.report
        end
      end
    RUBY
  end

  it "does not register an offense when report_flatten is called" do
    expect_no_offenses(<<~RUBY)
      RSpec.describe 'Users API' do
        before do
          @schema_coverage = Committee::Test::SchemaCoverage.new(schema)
          @committee_options[:schema_coverage] = @schema_coverage
        end

        after(:all) do
          @schema_coverage.report_flatten
        end
      end
    RUBY
  end

  it "does not register an offense when schema coverage is not used" do
    expect_no_offenses(<<~RUBY)
      RSpec.describe 'Users API' do
        before do
          @committee_options[:schema_path] = 'schema.yaml'
        end
      end
    RUBY
  end
end
