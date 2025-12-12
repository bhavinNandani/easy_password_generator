# frozen_string_literal: true

require "securerandom"

module PassForge
  # Pattern-based password generator
  # Generate passwords based on custom patterns
  class Pattern
    # Generate password from pattern
    #
    # @param pattern [String] Pattern string
    # @return [String] Generated password
    #
    # Pattern characters:
    # - C = uppercase letter
    # - c = lowercase letter
    # - v = lowercase vowel
    # - V = uppercase vowel
    # - 9 = digit
    # - ! = symbol
    # - Any other character = literal
    #
    # @example Generate from pattern
    #   PassForge::Pattern.generate("Cvccvc99!")
    #   # => "Rabmit42!"
    #
    def self.generate(pattern)
      raise ArgumentError, "Pattern cannot be empty" if pattern.nil? || pattern.empty?
      
      result = []
      
      pattern.each_char do |char|
        result << case char
                  when 'C'
                    Charsets::UPPER_CASE.sample
                  when 'c'
                    Charsets::LOWER_CASE.sample
                  when 'v'
                    Pronounceable::VOWELS.sample
                  when 'V'
                    Pronounceable::VOWELS.sample.upcase
                  when '9'
                    Charsets::NUMBERS.sample
                  when '!'
                    Charsets::SYMBOLS.sample
                  else
                    char # Literal character
                  end
      end
      
      result.join
    end
  end
end
