# frozen_string_literal: true

require "password_generator/version"
require "password_generator/charsets"
require "securerandom"
require "byebug"

module PasswordGenerator
  class Generator
    def self.generate(length = 12, upper_case: true, lower_case: true, numbers: true, symbols: false)
      charset = build_charset(upper_case, lower_case, numbers, symbols)
      raise ArgumentError, "At least one character set must be enabled" if charset.empty?

      Array.new(length) { charset.sample }.join
    end

    private

    def self.build_charset(upper_case, lower_case, numbers, symbols)
      charset = []
      charset += Charsets::UPPER_CASE if upper_case
      charset += Charsets::LOWER_CASE if lower_case
      charset += Charsets::NUMBERS if numbers
      charset += Charsets::SYMBOLS if symbols
      charset
    end
  end
end
