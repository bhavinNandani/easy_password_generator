require "thor"
require "passforge"

module PassForge
  class CLI < Thor
    desc "generate", "Generate a secure random password"
    method_option :length, type: :numeric, default: 16, aliases: "-l", desc: "Length of the password"
    method_option :symbols, type: :boolean, default: true, aliases: "-s", desc: "Include symbols"
    method_option :numbers, type: :boolean, default: true, aliases: "-n", desc: "Include numbers"
    def generate
      puts PassForge.random(
        length: options[:length],
        symbols: options[:symbols],
        numbers: options[:numbers]
      )
    end

    desc "passphrase", "Generate a memorable passphrase"
    method_option :words, type: :numeric, default: 4, aliases: "-w", desc: "Number of words"
    method_option :separator, type: :string, default: "-", aliases: "-s", desc: "Separator character"
    def passphrase
      puts PassForge.passphrase(
        words: options[:words],
        separator: options[:separator]
      )
    end

    desc "personal", "Generate a personal password based on keywords"
    method_option :keywords, type: :string, required: true, aliases: "-k", desc: "Comma-separated keywords (e.g. 'Bruce,Wayne,Batman')"
    def personal
      keywords_array = options[:keywords].split(",")
      puts PassForge.personal(keywords_array)
    end

    desc "analyze PASSWORD", "Analyze the strength of a password"
    def analyze(password)
      result = PassForge::Analyzer.analyze(password)
      puts "Score: #{result.score}/100"
      puts "Entropy: #{result.entropy.round(2)} bits"
      puts "Feedback: #{result.suggestions.join(', ')}"
    end

    desc "version", "Show PassForge version"
    def version
      puts "PassForge v#{PassForge::VERSION}"
    end
  end
end
