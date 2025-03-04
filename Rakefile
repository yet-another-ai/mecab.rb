# frozen_string_literal: true

require "bundler/gem_tasks"
require "minitest/test_task"

Minitest::TestTask.create

require "rubocop/rake_task"

RuboCop::RakeTask.new

require "rake/extensiontask"

desc "Build Ruby Gem"
task build: :compile

GEMSPEC = Gem::Specification.load("mecab.gemspec")

Rake::ExtensionTask.new("mecab", GEMSPEC) do |ext|
  ext.lib_dir = "lib/mecab"
end

task default: %i[clobber compile test rubocop]
