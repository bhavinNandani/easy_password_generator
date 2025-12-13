# frozen_string_literal: true

require_relative "lib/passforge/version"

Gem::Specification.new do |spec|
  spec.name = "passforge"
  spec.version = PassForge::VERSION
  spec.authors = ["Bhavin Nandani"]
  spec.email = ["nandanibhavin@gmail.com"]

  spec.summary = "A comprehensive password generation toolkit with passphrase support, strength analysis, and breach checking"
  spec.description = "PassForge is a feature-rich Ruby gem for generating secure passwords. It supports random passwords, memorable passphrases (XKCD-style), pronounceable passwords, pattern-based generation, password strength analysis, entropy calculation, and breach checking via HaveIBeenPwned API."
  spec.homepage = "https://github.com/bhavinNandani/passforge"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.7.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/bhavinNandani/passforge"
  spec.metadata["changelog_uri"] = "https://github.com/bhavinNandani/passforge/blob/main/CHANGELOG.md"
  spec.metadata["bug_tracker_uri"] = "https://github.com/bhavinNandani/passforge/issues"
  spec.metadata["documentation_uri"] = "https://rubydoc.info/gems/passforge"

  # Specify which files should be added to the gem when it is released.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "bin"
  spec.executables = ["passforge"]
  spec.require_paths = ["lib"]

  # Runtime dependencies
  spec.add_dependency "securerandom", "~> 0.3"
  spec.add_dependency "thor", "~> 1.2"

  # Development dependencies
  spec.add_development_dependency "byebug", "~> 11.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "~> 1.21"
  spec.add_development_dependency "simplecov", "~> 0.22"
  spec.add_development_dependency "webmock", "~> 3.0"
end
