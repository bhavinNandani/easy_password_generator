# frozen_string_literal: true

require "spec_helper"
require "webmock/rspec"

RSpec.describe PassForge::BreachChecker do
  describe ".check" do
    let(:mock_response) do
      <<~RESPONSE
        0018A45C4D1DEF81644B54AB7F969B88D65:1
        00D4F6E8FA6EECAD2A3AA415EEC418D38EC:2
        011053FD0102E94D6AE2F8B83D76FAF94F6:1
        012A7CA357541F0AC487871FEEC1891C49C:2
        0136E006E24E7D152139815FB0FC6A50B15:2
      RESPONSE
    end

    before do
      # Mock the API call
      stub_request(:get, /api.pwnedpasswords.com/)
        .to_return(status: 200, body: mock_response)
    end

    it "detects breached passwords" do
      # This will match the first hash in mock_response
      allow(Digest::SHA1).to receive(:hexdigest).and_return("AAAAA0018A45C4D1DEF81644B54AB7F969B88D65")
      
      result = PassForge::BreachChecker.check("test")
      expect(result[:breached]).to eq(true)
      expect(result[:count]).to eq(1)
    end

    it "detects non-breached passwords" do
      # This won't match any hash in mock_response
      allow(Digest::SHA1).to receive(:hexdigest).and_return("AAAAAZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ")
      
      result = PassForge::BreachChecker.check("test")
      expect(result[:breached]).to eq(false)
      expect(result[:count]).to eq(0)
    end

    it "raises error for empty password" do
      expect { PassForge::BreachChecker.check("") }.to raise_error(ArgumentError)
    end

    it "raises error for nil password" do
      expect { PassForge::BreachChecker.check(nil) }.to raise_error(ArgumentError)
    end

    it "handles API errors gracefully" do
      stub_request(:get, /api.pwnedpasswords.com/)
        .to_return(status: 500)
      
      result = PassForge::BreachChecker.check("test")
      expect(result[:breached]).to be_nil
      expect(result[:count]).to eq(0)
      expect(result).to have_key(:error)
    end
  end
end
