# PassForge

> 🔐 A comprehensive Ruby gem for generating secure, memorable passwords with built-in strength analysis and breach checking.

[![Gem Version](https://badge.fury.io/rb/passforge.svg)](https://badge.fury.io/rb/passforge)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

PassForge is a feature-rich password generation toolkit that goes beyond simple random passwords. Generate memorable passphrases, analyze password strength, check for breaches, and more.

## ✨ Features

- 🎲 **Random Passwords** - Fully customizable character sets
- 📝 **Memorable Passphrases** - XKCD-style word-based passwords
- 🛡️ **Strength Analysis** - Entropy calculation and crack time estimation
- 🔍 **Breach Checking** - HaveIBeenPwned API integration
- 🗣️ **Pronounceable Passwords** - Easier to type and remember *(coming soon)*
- 🎨 **Pattern-Based Generation** - Custom password patterns *(coming soon)*

## 📦 Installation

Add this line to your application's Gemfile:

```ruby
gem 'passforge'
```

And then execute:

```sh
$ bundle install
```

Or install it yourself as:

```sh
$ gem install passforge
```

## 🚀 Quick Start

```ruby
require 'passforge'

# Generate a basic password
password = PassForge.random(length: 16)
# => "aB3dE7gH9jK2mN5p"

# Generate with symbols
password = PassForge.random(length: 12, symbols: true)
# => "aB3!dE7@gH9#"

# Generate a passphrase
passphrase = PassForge.passphrase
# => "Correct-Horse-Battery-Staple"

# Analyze password strength
result = PassForge.analyze("MyP@ssw0rd123")
puts result.strength  # => :fair
puts result.score     # => 65
puts result.entropy   # => 85.21
puts result.suggestions  # => ["Use at least 12 characters"]
```

## 📖 Usage

### Random Password Generation

The `PassForge.random` method (or `PassForge::Generator.generate`) supports the following options:

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `length` | Integer | 12 | Length of the password |
| `upper_case` | Boolean | true | Include uppercase letters (A-Z) |
| `lower_case` | Boolean | true | Include lowercase letters (a-z) |
| `numbers` | Boolean | true | Include numbers (0-9) |
| `symbols` | Boolean | false | Include symbols (!@#$%^&*...) |
| `known_keywords` | String | "" | Comma-separated keywords to include |
| `mix` | Boolean | true | Mix keywords with random characters |

### Examples

**Basic password:**
```ruby
PassForge.random
# => "aB3dE7gH9jK2"
```

**Custom length with symbols:**
```ruby
PassForge.random(length: 20, symbols: true)
# => "aB3!dE7@gH9#jK2$mN5%"
```

**Lowercase and numbers only:**
```ruby
PassForge.random(length: 16, upper_case: false, symbols: false)
# => "a3d7g9j2m5p8r1t4"
```

**Using keywords (mixed with random characters):**
```ruby
PassForge.random(length: 16, known_keywords: "ruby,rails,code", mix: true)
# => "ruby3aB7gH9jK2mN"
```

**Using keywords only:**
```ruby
PassForge.random(length: 12, known_keywords: "dog,cat,fish", mix: false)
# => "dogcatfishdo"
```

### Passphrase Generation

Generate memorable, XKCD-style passphrases:

```ruby
# Basic passphrase (4 words)
PassForge.passphrase
# => "Correct-Horse-Battery-Staple"

# Custom word count
PassForge.passphrase(words: 6)
# => "Correct-Horse-Battery-Staple-Clipper-Amazing"

# Custom separator
PassForge.passphrase(words: 4, separator: " ")
# => "Correct Horse Battery Staple"

# With numbers
PassForge.passphrase(words: 4, numbers: true)
# => "Correct-Horse-Battery-Staple-42"

# Lowercase
PassForge.passphrase(words: 4, capitalize: false)
# => "correct-horse-battery-staple"
```

### Password Strength Analysis

Analyze password security:

```ruby
result = PassForge.analyze("MyP@ssw0rd123")

result.strength      # => :fair
result.score         # => 65 (0-100)
result.entropy       # => 85.21 bits
result.crack_time    # => "centuries"
result.suggestions   # => ["Use at least 12 characters"]

# Get hash representation
result.to_h
# => {
#   score: 65,
#   entropy: 85.21,
#   crack_time: "centuries",
#   strength: :fair,
#   suggestions: ["Use at least 12 characters"]
# }
```

**Strength Levels:**
- `:very_weak` - Easily cracked
- `:weak` - Vulnerable
- `:fair` - Acceptable for low-security
- `:strong` - Good for most uses
- `:very_strong` - Excellent security

### Breach Checking

Check if a password has been compromised in known data breaches:

```ruby
result = PassForge.breached?("password123")

result[:breached]  # => true
result[:count]     # => 2031380

# Check a secure password
result = PassForge.breached?("MySecureP@ssw0rd!")
result[:breached]  # => false
result[:count]     # => 0
```

**Privacy & Security:**
- Uses k-anonymity model (only sends first 5 chars of password hash)
- Your actual password never leaves your system
- Powered by HaveIBeenPwned API

## 🔮 Coming Soon

PassForge v1.1+ will include:

- **Pronounceable Passwords**: `PassForge.pronounceable(length: 12)` → easier to type
- **Pattern-Based**: `PassForge.pattern("Cvccvc99!")` → custom patterns
- **Batch Generation**: Generate multiple passwords at once

## 🛠️ Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run:

```sh
$ bundle exec rake install
```

## 🤝 Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bhavinNandani/passforge. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/bhavinNandani/passforge/blob/main/CODE_OF_CONDUCT.md).

## 📄 License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## 📜 Code of Conduct

Everyone interacting in the PassForge project's codebases, issue trackers, chat rooms, and mailing lists is expected to follow the [code of conduct](https://github.com/bhavinNandani/passforge/blob/main/CODE_OF_CONDUCT.md).
