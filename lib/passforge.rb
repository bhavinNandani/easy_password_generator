# frozen_string_literal: true

require "passforge/version"
require "passforge/charsets"
require "passforge/generator"
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
end
