# frozen_string_literal: true

require_relative "lib/linguin/version"

Gem::Specification.new do |spec|
  spec.name          = "linguin"
  spec.version       = Linguin::VERSION
  spec.authors       = ["Jan Schwenzien"]
  spec.email         = ["jan@general-scripting.com"]

  spec.summary       = "API wrapper for the language detection as a service Linguin AI."
  spec.description   = "This is a Ruby API wrapper for consuming the https://linguin.ai/ API allowing you "\
                       "to detect the language of a text fast and with high accuracy."
  spec.homepage      = "https://linguin.ai/"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.5.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/LinguinAI/linguin-ruby"
  spec.metadata["changelog_uri"] = "https://github.com/LinguinAI/linguin-ruby/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rubocop", "~> 1.7"
  spec.add_development_dependency "rubocop-minitest", "~> 0.12"
  spec.add_development_dependency "rubocop-rake", "~> 0.5"
  spec.add_development_dependency "webmock", "~> 3.12"

  spec.add_dependency "httparty"
end
