# frozen_string_literal: true

require "spec_helper"

RSpec.describe PassForge::Passphrase do
  describe ".generate" do
    it "generates a passphrase with default settings" do
      passphrase = PassForge::Passphrase.generate
      expect(passphrase).to be_a(String)
      expect(passphrase.split("-").length).to eq(4)
    end

    it "generates a passphrase with specified word count" do
      passphrase = PassForge::Passphrase.generate(words: 6)
      expect(passphrase.split("-").length).to eq(6)
    end

    it "generates a passphrase with custom separator" do
      passphrase = PassForge::Passphrase.generate(separator: " ")
      expect(passphrase).to include(" ")
      expect(passphrase).not_to include("-")
    end

    it "generates a passphrase without capitalization" do
      passphrase = PassForge::Passphrase.generate(capitalize: false)
      expect(passphrase).to eq(passphrase.downcase)
    end

    it "generates a passphrase with numbers" do
      passphrase = PassForge::Passphrase.generate(numbers: true)
      expect(passphrase).to match(/\d+$/)
    end

    it "raises error for too few words" do
      expect { PassForge::Passphrase.generate(words: 1) }.to raise_error(ArgumentError)
    end

    it "raises error for too many words" do
      expect { PassForge::Passphrase.generate(words: 11) }.to raise_error(ArgumentError)
    end

    it "generates unique passphrases" do
      passphrase1 = PassForge::Passphrase.generate
      passphrase2 = PassForge::Passphrase.generate
      expect(passphrase1).not_to eq(passphrase2)
    end
  end

  describe ".entropy" do
    it "calculates entropy for 4 words" do
      entropy = PassForge::Passphrase.entropy(words: 4)
      expect(entropy).to be > 30
      expect(entropy).to be < 50
    end

    it "increases entropy with more words" do
      entropy4 = PassForge::Passphrase.entropy(words: 4)
      entropy6 = PassForge::Passphrase.entropy(words: 6)
      expect(entropy6).to be > entropy4
    end
  end

  describe ".crack_time" do
    it "returns a human-readable time estimate" do
      time = PassForge::Passphrase.crack_time(words: 4)
      expect(time).to be_a(String)
      expect(time.length).to be > 0
    end

    it "shows longer time for more words" do
      time4 = PassForge::Passphrase.crack_time(words: 4)
      time6 = PassForge::Passphrase.crack_time(words: 6)
      # Both should contain time units
      expect(time4).to match(/\d+/)
      expect(time6).to match(/\d+/)
    end
  end
end

RSpec.describe PassForge::Wordlist do
  describe ".random_word" do
    it "returns a word from the wordlist" do
      word = PassForge::Wordlist.random_word
      expect(word).to be_a(String)
      expect(PassForge::Wordlist::WORDS).to include(word)
    end
  end

  describe ".random_words" do
    it "returns specified number of words" do
      words = PassForge::Wordlist.random_words(5)
      expect(words.length).to eq(5)
    end

    it "returns unique words" do
      words = PassForge::Wordlist.random_words(10)
      expect(words.uniq.length).to eq(10)
    end
  end
end
