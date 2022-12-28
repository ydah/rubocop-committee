# RuboCop Committee

Committee-specific analysis for your projects, as an extension to
[RuboCop](https://github.com/rubocop/rubocop).

## Installation

Just install the `rubocop-committee` gem

```bash
gem install rubocop-committee
```

or if you use bundler put this in your `Gemfile`

```
gem 'rubocop-committee', require: false
```

## Usage

You need to tell RuboCop to load the Committee extension. There are two
ways to do this:

### RuboCop configuration file

Put this into your `.rubocop.yml`.

```yaml
require: rubocop-committee
```

Alternatively, use the following array notation when specifying multiple extensions.

```yaml
require:
  - rubocop-other-extension
  - rubocop-committee
```

Now you can run `rubocop` and it will automatically load the RuboCop Committee
cops together with the standard cops.

### Command line

```bash
rubocop --require rubocop-committee
```

### Rake task

```ruby
RuboCop::RakeTask.new do |task|
  task.requires << 'rubocop-committee'
end
```

## Documentation

You can read more about RuboCop Committee in its official manual.

## The Cops

All cops are located under
[`lib/rubocop/cop/committee`](lib/rubocop/cop/committee), and contain
examples/documentation.

In your `.rubocop.yml`, you may treat the Committee cops just like any other
cop. For example:

```yaml
Committee/FilePath:
  Exclude:
    - spec/my_poorly_named_spec_file.rb
```

## Contributing

Checkout the [contribution guidelines](.github/CONTRIBUTING.md).

## License

`rubocop-committee` is MIT licensed. [See the accompanying file](MIT-LICENSE.md) for
the full text.
