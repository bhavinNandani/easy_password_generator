# frozen_string_literal: true

require "spec_helper"
require "password_generator"

RSpec.describe PasswordGenerator do
  it "has a version number" do
    expect(PasswordGenerator::VERSION).not_to be nil
  end
end

RSpec.describe PasswordGenerator::Generator do
  describe ".generate" do
    context "with default settings" do
      it "generates a password of default length 12" do
        password = PasswordGenerator::Generator.generate
        expect(password.length).to eq(12)
      end

      it "generates an alphanumeric password" do
        password = PasswordGenerator::Generator.generate
        expect(password).to match(/^[a-zA-Z0-9]+$/)
      end

      it "generates unique passwords each time" do
        password1 = PasswordGenerator::Generator.generate
        password2 = PasswordGenerator::Generator.generate
        expect(password1).not_to eq(password2)
      end
    end

    context "with custom settings" do
      it "generates a password of specified length" do
        password = PasswordGenerator::Generator.generate(16)
        expect(password.length).to eq(16)
      end

      it "excludes upper case letters when upper_case is false" do
        password = PasswordGenerator::Generator.generate(12, upper_case: false)
        expect(password).not_to match(/[A-Z]/)
      end

      it "excludes lower case letters when lower_case is false" do
        password = PasswordGenerator::Generator.generate(12, lower_case: false)
        expect(password).not_to match(/[a-z]/)
      end

      it "excludes numbers when numbers is false" do
        password = PasswordGenerator::Generator.generate(12, numbers: false)
        expect(password).not_to match(/[0-9]/)
      end

      it "includes symbols when symbols is true" do
        password = PasswordGenerator::Generator.generate(12, symbols: true)
        expect(password).to match(/[!@#$%^&*\-_+=]/)
      end

      it "raises an error if all character sets are disabled" do
        expect do
          PasswordGenerator::Generator.generate(12, upper_case: false, lower_case: false, numbers: false,
                                                    symbols: false)
        end.to raise_error(ArgumentError, "At least one character set must be enabled")
      end
    end

    context "with known keywords" do
      it "generates a password using only known keywords when mix is false" do
        password = PasswordGenerator::Generator.generate(12, known_keywords: "dog,cat,fish", mix: false)
        expect(password.length).to eq(12)
        known_keywords = %w[dog cat fish]
        expect(known_keywords.any? { |kw| password.include?(kw) }).to be true
      end

      it "generates a mixed password with known keywords and random characters when mix is true" do
        password = PasswordGenerator::Generator.generate(12, known_keywords: "dog,cat,fish", mix: true)
        expect(password.length).to eq(12)
        known_keywords = %w[dog cat fish]
        expect(known_keywords.any? { |kw| password.include?(kw) }).to be true
        expect(password).to match(/^[a-zA-Z0-9!@#$%^&*\-_+=]+$/)
      end

      it "handles keywords longer than the specified length" do
        password = PasswordGenerator::Generator.generate(5, known_keywords: "elephant", mix: false)
        expect(password.length).to eq(5)
        expect(password).to eq("eleph")
      end

      it "generates a password with exact length when using only known keywords" do
        password = PasswordGenerator::Generator.generate(15, known_keywords: "alpha,beta,gamma", mix: false)
        expect(password.length).to eq(15)
        known_keywords = %w[alpha beta gamma]
        expect(known_keywords.any? { |kw| password.include?(kw) }).to be true
      end
    end
  end
end
