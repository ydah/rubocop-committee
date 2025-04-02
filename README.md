# RuboCop Committee

![GitHub top language](https://img.shields.io/github/languages/top/ydah/rubocop-committee?color=39ff14) [![Gem Version](https://badge.fury.io/rb/rubocop-committee.svg)](https://badge.fury.io/rb/rubocop-committee) [![Ruby Style Guide](https://img.shields.io/badge/code_style-rubocop-brightgreen.svg)](https://github.com/rubocop/rubocop) [![CI](https://github.com/ydah/rubocop-committee/actions/workflows/ci.yml/badge.svg)](https://github.com/ydah/rubocop-committee/actions/workflows/ci.yml) [![Maintainability](https://api.codeclimate.com/v1/badges/a1b121696e9d1b425406/maintainability)](https://codeclimate.com/github/ydah/rubocop-committee/maintainability)

[Committee](https://github.com/interagent/committee)-specific analysis for your projects, as an extension to
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
plugins: rubocop-committee
```

Alternatively, use the following array notation when specifying multiple extensions.

```yaml
plugins:
  - rubocop-other-extension
  - rubocop-committee
```

Now you can run `rubocop` and it will automatically load the RuboCop Committee
cops together with the standard cops.

> [!NOTE]
> The plugin system is supported in RuboCop 1.72+. In earlier versions, use `require` instead of `plugins`.

### Command line

```bash
rubocop --plugin rubocop-committee
```

### Rake task

```ruby
RuboCop::RakeTask.new do |task|
  task.plugins << 'rubocop-committee'
end
```

## Documentation

You can read more about RuboCop Committee in its [official manual](https://ydah.github.io/rubocop.docs/rubocop-committee/).

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
