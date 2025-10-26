# frozen_string_literal: true

require "easy_password_generator/version"
require "easy_password_generator/charsets"
require "securerandom"
require "byebug"

module EasyPasswordGenerator
  # class for passowrd generator
  class Generator
    def self.generate(length = 12, upper_case: true, lower_case: true, numbers: true, symbols: false, known_keywords: "", mix: true)
      charset = build_charset(upper_case, lower_case, numbers, symbols)
      raise ArgumentError, "At least one character set must be enabled" if charset.empty? && known_keywords.empty?

      if mix && !known_keywords.empty?
        generate_mixed_password(length, charset, known_keywords)
      elsif !known_keywords.empty?
        generate_keyword_only_password(length, known_keywords, charset)
      else
        generate_random_password(length, charset)
      end
    end

    def self.build_charset(upper_case, lower_case, numbers, symbols)
      charset = []
      charset += Charsets::UPPER_CASE if upper_case
      charset += Charsets::LOWER_CASE if lower_case
      charset += Charsets::NUMBERS if numbers
      charset += Charsets::SYMBOLS if symbols
      charset
    end

    def self.generate_mixed_password(length, charset, known_keywords)
      password = Array.new(length) { charset.sample }

      keywords_array = known_keywords.split(",")
      keyword = keywords_array.sample
      keyword_length = keyword.length
      keyword_pos = SecureRandom.random_number(length - keyword_length + 1)
      password[keyword_pos, keyword_length] = keyword.chars

      password.join
    end

    def self.generate_keyword_only_password(length, known_keywords, _charset)
      keywords_array = known_keywords.split(",")
      password = []
      remaining_length = length

      while remaining_length.positive?
        keyword = keywords_array.select { |k| k.length <= remaining_length }.sample

        if keyword.nil?
          # If no keyword fits exactly, fill the remaining space with parts of keywords
          keyword = keywords_array.sample
          keyword_part = keyword[0, remaining_length]
          password.concat(keyword_part.chars)
          remaining_length -= keyword_part.length
        else
          password.concat(keyword.chars)
          remaining_length -= keyword.length
        end
      end

      # If the password is shorter than the required length, fill with additional keyword parts
      while password.length < length
        keyword = keywords_array.sample
        remaining_length = length - password.length
        password.concat(keyword[0, remaining_length].chars)
      end

      password.join
    end

    def self.generate_random_password(length, charset)
      Array.new(length) { charset.sample }.join
    end
  end
end
