# frozen_string_literal: true

require_relative "lib/mecab/version"

Gem::Specification.new do |spec|
  spec.name = "yai_mecab"
  spec.version = Mecab::VERSION
  spec.authors = ["Yet Another AI"]
  spec.email = ["rubygems@yetanother.ai"]

  spec.summary = "mecab Ruby binding"
  spec.description = "Ruby binding for mecab"
  spec.homepage = "https://github.com/yet-another-ai/mecab.rb"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.require_paths = ["lib"]
  spec.extensions = ["ext/mecab/extconf.rb"]
  spec.metadata["rubygems_mfa_required"] = "true"
end
