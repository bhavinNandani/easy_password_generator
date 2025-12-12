# frozen_string_literal: true

module PassForge
  # Batch password generator
  # Generate multiple passwords at once
  class Batch
    # Generate multiple passwords
    #
    # @param count [Integer] Number of passwords to generate
    # @param type [Symbol] Type of password (:random, :passphrase, :pronounceable, :pattern)
    # @param options [Hash] Options for the generator
    # @return [Array<String>] Array of generated passwords
    #
    # @example Generate 10 random passwords
    #   PassForge::Batch.generate(10, :random, length: 16)
    #   # => ["aB3dE7gH9jK2mN5p", "xY9zA2bC4dE6fG8h", ...]
    #
    def self.generate(count, type = :random, **options)
      raise ArgumentError, "Count must be at least 1" if count < 1
      raise ArgumentError, "Count must be at most 1000" if count > 1000
      
      passwords = []
      
      count.times do
        password = case type
                   when :random
                     length = options.delete(:length) || 12
                     Generator.generate(length, **options)
                   when :passphrase
                     Passphrase.generate(**options)
                   when :pronounceable
                     Pronounceable.generate(**options)
                   when :pattern
                     Pattern.generate(options[:pattern] || "Cvccvc99!")
                   else
                     raise ArgumentError, "Unknown type: #{type}"
                   end
        
        passwords << password
      end
      
      passwords
    end
    
    # Export passwords to CSV format
    # @param passwords [Array<String>] Passwords to export
    # @return [String] CSV string
    def self.to_csv(passwords)
      "Password\n" + passwords.join("\n")
    end
    
    # Export passwords to JSON format
    # @param passwords [Array<String>] Passwords to export
    # @return [String] JSON string
    def self.to_json(passwords)
      require "json"
      { passwords: passwords, count: passwords.length, generated_at: Time.now.iso8601 }.to_json
    end
  end
end
