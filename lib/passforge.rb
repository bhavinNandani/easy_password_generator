# frozen_string_literal: true

require "passforge/version"
require "passforge/charsets"
require "passforge/wordlist"
require "passforge/generator"
require "passforge/passphrase"
require "passforge/analyzer"
require "passforge/breach_checker"
require "passforge/pronounceable"
require "passforge/pattern"
require "passforge/batch"
require "passforge/personal"
require "securerandom"

# PassForge - A comprehensive password generation toolkit
#
# @example Generate a random password
#   PassForge.random(length: 16, symbols: true)
#
# @example Generate a passphrase
#   PassForge.passphrase(words: 4, separator: '-')
#
module PassForge
  class Error < StandardError; end

  # Generate a random password
  # @param length [Integer] Length of the password
  # @param options [Hash] Generation options
  # @return [String] Generated password
  def self.random(length: 12, **options)
    Generator.generate(length, **options)
  end

  # Generate a passphrase
  # @param options [Hash] Passphrase options
  # @return [String] Generated passphrase
  def self.passphrase(**options)
    Passphrase.generate(**options)
  end

  # Analyze password strength
  # @param password [String] Password to analyze
  # @return [Analyzer::Result] Analysis result
  def self.analyze(password)
    Analyzer.analyze(password)
  end

  # Check if password has been breached
  # @param password [String] Password to check
  # @return [Hash] Breach information
  def self.breached?(password)
    BreachChecker.check(password)
  end

  # Generate a pronounceable password
  # @param options [Hash] Generation options
  # @return [String] Generated password
  def self.pronounceable(**options)
    Pronounceable.generate(**options)
  end

  # Generate password from pattern
  # @param pattern [String] Pattern string
  # @return [String] Generated password
  def self.pattern(pattern)
    Pattern.generate(pattern)
  end

  # Generate multiple passwords
  # @param count [Integer] Number of passwords
  # @param type [Symbol] Type of password
  # @param options [Hash] Generation options
  # @return [Array<String>] Generated passwords
  def self.batch(count, type = :random, **options)
    Batch.generate(count, type, **options)
  end

  # Generate a personalized password
  # @param keywords [Array<String>] Personal keywords
  # @param options [Hash] Generation options
  # @return [String] Generated password
  def self.personal(keywords, **options)
    Personal.generate(keywords, **options)
  end
end
