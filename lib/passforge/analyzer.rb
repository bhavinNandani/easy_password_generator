# frozen_string_literal: true

module PassForge
  # Password strength analyzer
  # Evaluates password security and provides recommendations
  class Analyzer
    # Analysis result object
    class Result
      attr_reader :password, :score, :entropy, :crack_time, :strength, :suggestions

      def initialize(password:, score:, entropy:, crack_time:, strength:, suggestions:)
        @password = password
        @score = score
        @entropy = entropy
        @crack_time = crack_time
        @strength = strength
        @suggestions = suggestions
      end

      def to_h
        {
          score: @score,
          entropy: @entropy.round(2),
          crack_time: @crack_time,
          strength: @strength,
          suggestions: @suggestions
        }
      end
    end

    # Analyze password strength
    #
    # @param password [String] Password to analyze
    # @return [Result] Analysis result
    #
    # @example Analyze a password
    #   result = PassForge::Analyzer.analyze("MyP@ssw0rd")
    #   result.strength  # => :fair
    #   result.entropy   # => 45.6
    #   result.suggestions  # => ["Add more characters", "Include symbols"]
    #
    def self.analyze(password)
      raise ArgumentError, "Password cannot be empty" if password.nil? || password.empty?

      entropy = calculate_entropy(password)
      crack_time = estimate_crack_time(entropy)
      strength = determine_strength(entropy, password)
      score = calculate_score(entropy, password)
      suggestions = generate_suggestions(password, entropy)

      Result.new(
        password: password,
        score: score,
        entropy: entropy,
        crack_time: crack_time,
        strength: strength,
        suggestions: suggestions
      )
    end

    # Calculate password entropy (bits of randomness)
    # @private
    def self.calculate_entropy(password)
      charset_size = determine_charset_size(password)
      length = password.length
      
      # Entropy = log2(charset_size^length)
      Math.log2(charset_size**length)
    end

    # Determine character set size
    # @private
    def self.determine_charset_size(password)
      size = 0
      size += 26 if password =~ /[a-z]/
      size += 26 if password =~ /[A-Z]/
      size += 10 if password =~ /[0-9]/
      size += 32 if password =~ /[^a-zA-Z0-9]/
      size
    end

    # Estimate crack time based on entropy
    # @private
    def self.estimate_crack_time(entropy)
      guesses_per_second = 1_000_000_000 # 1 billion guesses/sec
      total_guesses = 2**entropy
      seconds = total_guesses / guesses_per_second / 2 # Average case
      
      format_time(seconds)
    end

    # Format time in human-readable format
    # @private
    def self.format_time(seconds)
      return "instant" if seconds < 1
      return "#{seconds.to_i} seconds" if seconds < 60
      return "#{(seconds / 60).to_i} minutes" if seconds < 3600
      return "#{(seconds / 3600).to_i} hours" if seconds < 86_400
      return "#{(seconds / 86_400).to_i} days" if seconds < 31_536_000
      return "#{(seconds / 31_536_000).to_i} years" if seconds < 31_536_000_000
      
      "centuries"
    end

    # Determine strength level
    # @private
    def self.determine_strength(entropy, password)
      # Check for common patterns
      return :very_weak if common_password?(password)
      
      case entropy
      when 0...28
        :very_weak
      when 28...36
        :weak
      when 36...60
        :fair
      when 60...128
        :strong
      else
        :very_strong
      end
    end

    # Calculate numeric score (0-100)
    # @private
    def self.calculate_score(entropy, password)
      base_score = [entropy * 1.5, 100].min
      
      # Penalties
      base_score -= 10 if password.length < 8
      base_score -= 15 if common_password?(password)
      base_score -= 5 if password =~ /^[a-z]+$/  # All lowercase
      base_score -= 5 if password =~ /^[A-Z]+$/  # All uppercase
      base_score -= 5 if password =~ /^[0-9]+$/  # All numbers
      
      # Bonuses
      base_score += 5 if password.length > 12
      base_score += 5 if password.length > 16
      base_score += 10 if has_all_char_types?(password)
      
      [[base_score, 0].max, 100].min.to_i
    end

    # Check if password has all character types
    # @private
    def self.has_all_char_types?(password)
      password =~ /[a-z]/ &&
        password =~ /[A-Z]/ &&
        password =~ /[0-9]/ &&
        password =~ /[^a-zA-Z0-9]/
    end

    # Check if password is common
    # @private
    def self.common_password?(password)
      common_passwords = %w[
        password 123456 12345678 qwerty abc123 monkey 1234567 letmein
        trustno1 dragon baseball iloveyou master sunshine ashley bailey
        passw0rd shadow 123123 654321 superman qazwsx michael football
      ]
      
      common_passwords.include?(password.downcase)
    end

    # Generate improvement suggestions
    # @private
    def self.generate_suggestions(password, entropy)
      suggestions = []
      
      suggestions << "Use at least 12 characters" if password.length < 12
      suggestions << "Add uppercase letters" unless password =~ /[A-Z]/
      suggestions << "Add lowercase letters" unless password =~ /[a-z]/
      suggestions << "Add numbers" unless password =~ /[0-9]/
      suggestions << "Add symbols (!@#$%^&*)" unless password =~ /[^a-zA-Z0-9]/
      suggestions << "Avoid common passwords" if common_password?(password)
      suggestions << "Consider using a passphrase" if entropy < 50
      
      suggestions
    end
  end
end
