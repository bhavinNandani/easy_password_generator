# frozen_string_literal: true

require "digest/sha1"
require "net/http"
require "uri"

module PassForge
  # Breach checker using HaveIBeenPwned API
  # Uses k-anonymity to preserve privacy (only sends first 5 chars of hash)
  class BreachChecker
    API_URL = "https://api.pwnedpasswords.com/range/"

    # Check if password has been breached
    #
    # @param password [String] Password to check
    # @return [Hash] Breach information
    #
    # @example Check a password
    #   result = PassForge::BreachChecker.check("password123")
    #   result[:breached]  # => true
    #   result[:count]     # => 2_389_234
    #
    def self.check(password)
      # Ensure ArgumentError is raised before the rescue block
      if password.nil? || password.empty?
        raise ArgumentError, "Password cannot be empty"
      end

      # Generate SHA-1 hash
      hash = Digest::SHA1.hexdigest(password).upcase
      prefix = hash[0..4]
      suffix = hash[5..-1]

      # Query API with prefix only (k-anonymity)
      response = query_api(prefix)
      
      return { breached: nil, count: 0, error: "API unreachable" } if response.nil?

      # Check if our suffix appears in the response
      count = parse_response(response, suffix)
      
      {
        breached: count > 0,
        count: count
      }
    rescue StandardError => e
      # Return safe default or re-raise if it's an ArgumentError
      raise e if e.is_a?(ArgumentError)

      # Return safe default on other errors
      {
        breached: nil,
        count: 0,
        error: e.message
      }
    end

    # Query HaveIBeenPwned API
    # @private
    def self.query_api(prefix)
      uri = URI("#{API_URL}#{prefix}")
      
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.open_timeout = 5
      http.read_timeout = 5
      
      request = Net::HTTP::Get.new(uri)
      request["User-Agent"] = "PassForge-RubyGem"
      
      response = http.request(request)
      
      return nil unless response.is_a?(Net::HTTPSuccess)
      
      response.body
    end

    # Parse API response to find suffix match
    # @private
    def self.parse_response(response, suffix)
      response.each_line do |line|
        hash_suffix, count = line.strip.split(":")
        return count.to_i if hash_suffix == suffix
      end
      
      0
    end
  end
end
