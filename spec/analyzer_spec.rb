# frozen_string_literal: true

require "spec_helper"

RSpec.describe PassForge::Analyzer do
  describe ".analyze" do
    it "analyzes a strong password" do
      result = PassForge::Analyzer.analyze("Tr0ub4dor&3")
      expect(result).to be_a(PassForge::Analyzer::Result)
      expect(result.strength).to be_a(Symbol)
      expect(result.entropy).to be > 0
      expect(result.score).to be_between(0, 100)
    end

    it "detects weak passwords" do
      result = PassForge::Analyzer.analyze("password")
      expect(result.strength).to eq(:very_weak)
      expect(result.suggestions).not_to be_empty
    end

    it "detects common passwords" do
      result = PassForge::Analyzer.analyze("123456")
      expect(result.strength).to eq(:very_weak)
    end

    it "provides suggestions for improvement" do
      result = PassForge::Analyzer.analyze("abc")
      expect(result.suggestions).to include("Use at least 12 characters")
      expect(result.suggestions).to include("Add uppercase letters")
      expect(result.suggestions).to include("Add numbers")
    end

    it "calculates entropy correctly" do
      result = PassForge::Analyzer.analyze("aB3!")
      expect(result.entropy).to be > 0
    end

    it "estimates crack time" do
      result = PassForge::Analyzer.analyze("MyP@ssw0rd")
      expect(result.crack_time).to be_a(String)
    end

    it "returns hash representation" do
      result = PassForge::Analyzer.analyze("Test123!")
      hash = result.to_h
      expect(hash).to have_key(:score)
      expect(hash).to have_key(:entropy)
      expect(hash).to have_key(:strength)
      expect(hash).to have_key(:suggestions)
    end

    it "raises error for empty password" do
      expect { PassForge::Analyzer.analyze("") }.to raise_error(ArgumentError)
    end

    it "raises error for nil password" do
      expect { PassForge::Analyzer.analyze(nil) }.to raise_error(ArgumentError)
    end
  end
end
