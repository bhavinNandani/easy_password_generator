# frozen_string_literal: true

# lib/password_generator/charsets.rb
module PasswordGenerator
  module Charsets
    UPPER_CASE = ("A".."Z").to_a.freeze
    LOWER_CASE = ("a".."z").to_a.freeze
    NUMBERS = ("0".."9").to_a.freeze
    SYMBOLS = %w[! @ # $ % ^ & * - _ = +].freeze
  end
end
