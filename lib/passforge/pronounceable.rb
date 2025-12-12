# frozen_string_literal: true

require "securerandom"

module PassForge
  # Pronounceable password generator
  # Creates passwords that are easier to type and remember
  class Pronounceable
    CONSONANTS = %w[b c d f g h j k l m n p r s t v w x z].freeze
    VOWELS = %w[a e i o u].freeze
    
    # Generate a pronounceable password
    #
    # @param length [Integer] Length of the password (default: 12)
    # @param capitalize [Boolean] Capitalize first letter (default: true)
    # @param numbers [Boolean] Include numbers (default: true)
    # @param symbols [Boolean] Include symbols (default: false)
    # @return [String] Generated pronounceable password
    #
    # @example Generate a pronounceable password
    #   PassForge::Pronounceable.generate(12)
    #   # => "Tuvaxo8qiba#"
    #
    def self.generate(length: 12, capitalize: true, numbers: true, symbols: false)
      raise ArgumentError, "Length must be at least 4" if length < 4
      
      # Reserve space for numbers and symbols
      letter_count = length
      letter_count -= 2 if numbers
      letter_count -= 1 if symbols
      
      # Generate pronounceable base
      password = generate_pronounceable_string(letter_count)
      
      # Capitalize first letter
      password[0] = password[0].upcase if capitalize
      
      # Add numbers
      if numbers
        2.times { password += SecureRandom.random_number(10).to_s }
      end
      
      # Add symbol
      if symbols
        symbol = Charsets::SYMBOLS.sample
        password += symbol
      end
      
      password
    end
    
    # Generate pronounceable string by alternating consonants and vowels
    # @private
    def self.generate_pronounceable_string(length)
      result = []
      use_consonant = [true, false].sample
      
      length.times do
        if use_consonant
          result << CONSONANTS.sample
        else
          result << VOWELS.sample
        end
        use_consonant = !use_consonant
      end
      
      result.join
    end
  end
end
