# frozen_string_literal: true

require "securerandom"

module PassForge
  # Passphrase generator for creating memorable, XKCD-style passwords
  # Uses EFF's long wordlist for maximum security and memorability
  class Passphrase
    # Generate a passphrase
    #
    # @param words [Integer] Number of words in the passphrase (default: 4)
    # @param separator [String] Character(s) to separate words (default: "-")
    # @param capitalize [Boolean] Capitalize first letter of each word (default: true)
    # @param numbers [Boolean] Add a random number at the end (default: false)
    # @return [String] Generated passphrase
    #
    # @example Generate a basic passphrase
    #   PassForge::Passphrase.generate
    #   # => "Correct-Horse-Battery-Staple"
    #
    # @example Generate with custom separator
    #   PassForge::Passphrase.generate(words: 5, separator: " ")
    #   # => "Correct Horse Battery Staple Clipper"
    #
    # @example Generate with numbers
    #   PassForge::Passphrase.generate(words: 4, numbers: true)
    #   # => "Correct-Horse-Battery-Staple-42"
    #
    def self.generate(words: 4, separator: "-", capitalize: true, numbers: false)
      raise ArgumentError, "Words must be at least 2" if words < 2
      raise ArgumentError, "Words must be at most 10" if words > 10

      selected_words = Wordlist.random_words(words)
      
      # Capitalize if requested
      selected_words = selected_words.map(&:capitalize) if capitalize
      
      # Join with separator
      passphrase = selected_words.join(separator)
      
      # Add random number if requested
      passphrase += "#{separator}#{SecureRandom.random_number(100)}" if numbers
      
      passphrase
    end

    # Calculate entropy of a passphrase
    # @param words [Integer] Number of words
    # @return [Float] Entropy in bits
    def self.entropy(words:)
      # EFF wordlist has 7,776 words (2^12.9)
      # Entropy = log2(possibilities^words)
      # For our wordlist: log2(1000^words) ≈ 9.97 * words
      wordlist_size = Wordlist::WORDS.length
      Math.log2(wordlist_size) * words
    end

    # Estimate crack time for a passphrase
    # @param words [Integer] Number of words
    # @return [String] Human-readable crack time estimate
    def self.crack_time(words:)
      ent = entropy(words: words)
      guesses_per_second = 1_000_000_000 # 1 billion guesses/sec
      
      total_guesses = 2**ent
      seconds = total_guesses / guesses_per_second
      
      format_time(seconds)
    end

    # Format seconds into human-readable time
    # @private
    def self.format_time(seconds)
      return "instant" if seconds < 1
      return "#{seconds.to_i} seconds" if seconds < 60
      return "#{(seconds / 60).to_i} minutes" if seconds < 3600
      return "#{(seconds / 3600).to_i} hours" if seconds < 86_400
      return "#{(seconds / 86_400).to_i} days" if seconds < 31_536_000
      return "#{(seconds / 31_536_000).to_i} years" if seconds < 31_536_000_000
      
      "#{(seconds / 31_536_000_000).to_i} millennia"
    end
  end
end
