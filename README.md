# PasswordGenerator

`PasswordGenerator` is a Ruby gem that allows you to generate secure passwords with customizable settings. It supports generating passwords with a mix of upper case letters, lower case letters, numbers, symbols, and known keywords.

## Installation

To install the gem and add it to the application's Gemfile, execute:

```sh
$ bundle add password_generator
```

If bundler is not being used to manage dependencies, install the gem by executing:

```sh
$ gem install password_generator
```

## Usage

To generate a password, use the `PasswordGenerator::Generator.generate` method. The method supports the following parameters:

- `length` (default: 12): The length of the password to be generated.
- `upper_case` (default: true): Include upper case letters.
- `lower_case` (default: true): Include lower case letters.
- `numbers` (default: true): Include numbers.
- `symbols` (default: false): Include symbols.
- `known_keywords` (default: nil): A comma-separated string of known keywords to include in the password.
- `mix` (default: true): Mix known keywords with random characters.

### Examples

Generate a default password:

```ruby
password = PasswordGenerator::Generator.generate
puts password
```

Generate a password with specific settings:

```ruby
password = PasswordGenerator::Generator.generate(16, upper_case: false, symbols: true)
puts password
```

Generate a password using known keywords only:

```ruby
password = PasswordGenerator::Generator.generate(12, known_keywords: "dog,cat,fish", mix: false)
puts password
```

Generate a password using a mix of known keywords and random characters:

```ruby
password = PasswordGenerator::Generator.generate(12, known_keywords: "dog,cat,fish", mix: true)
puts password
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run:

```sh
$ bundle exec rake install
```

To release a new version, update the version number in `version.rb`, and then run:

```sh
$ bundle exec rake release
```

This will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/password_generator. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/password_generator/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the PasswordGenerator project's codebases, issue trackers, chat rooms, and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/password_generator/blob/main/CODE_OF_CONDUCT.md).
