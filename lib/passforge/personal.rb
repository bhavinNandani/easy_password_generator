# frozen_string_literal: true

module PassForge
  # Personal password generator
  # Generates strong passwords based on user-provided keywords
  class Personal
    LEET_MAP = {
      'a' => '@', 'e' => '3', 'i' => '1', 'o' => '0', 's' => '$', 't' => '7'
    }.freeze

    # Generate a personalized password
    #
    # @param keywords [Array<String>] Personal keywords (e.g., name, city, year)
    # @param leetspeak [Boolean] Apply leetspeak transformation (default: true)
    # @param capitalize [Boolean] Capitalize words (default: true)
    # @param shuffle [Boolean] Shuffle order of words (default: false)
    # @param separator [String] Separator between words (default: "")
    # @param salt [Boolean] Add random numbers/symbols (default: true)
    # @return [String] Generated password
    #
    # @example
    #   PassForge::Personal.generate(["john", "london", "1990"])
    #   # => "John@L0nd0n#1990"
    #
    def self.generate(keywords, leetspeak: true, capitalize: true, shuffle: false, separator: "", salt: true)
      raise ArgumentError, "Keywords cannot be empty" if keywords.nil? || keywords.empty?

      # Process words
      words = keywords.map(&:dup)
      words.shuffle! if shuffle

      processed_words = words.map do |word|
        w = word.dup
        w.capitalize! if capitalize
        w = apply_leetspeak(w) if leetspeak
        w
      end

      # Join words
      password = processed_words.join(separator)

      # Add salt (numbers/symbols) if requested, but keep it memorable
      # We add it at the end or between words if no separator
      if salt
        password += Charsets::Symbols.sample
        password += rand(10..99).to_s
      end

      password
    end

    def self.apply_leetspeak(word)
      word.chars.map { |c| LEET_MAP[c.downcase] || c }.join
    end
  end
end
