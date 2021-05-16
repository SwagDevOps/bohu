# frozen_string_literal: true
# vim: ai ts=2 sts=2 et sw=2 ft=ruby
# rubocop:disable all

Gem::Specification.new do |s|
  s.name        = "bohu"
  s.version     = "0.0.1"
  s.date        = "2017-08-14"
  s.summary     = "Before the creation of light"
  s.description = "Easify some administrative tasks in primordial conditions"

  s.licenses    = ["GPL-3.0"]
  s.authors     = ["Dimitri Arrigoni"]
  s.email       = "dimitri@arrigoni.me"
  s.homepage    = "https://github.com/SwagDevOps/bohu"

  s.required_ruby_version = ">= 2.5.0"
  s.require_paths = ["lib"]

  s.files = [
    ".yardopts",
    "README.md",
    "lib/bohu.rb",
    "lib/bohu/bundleable.rb",
    "lib/bohu/command.rb",
    "lib/bohu/command/dialect.rb",
    "lib/bohu/command/dialect/missing_error.rb",
    "lib/bohu/command/runner.rb",
    "lib/bohu/commands.rb",
    "lib/bohu/commands/base_command.rb",
    "lib/bohu/commands/callable.rb",
    "lib/bohu/commands/loader.rb",
    "lib/bohu/commands/shell.rb",
    "lib/bohu/config.rb",
    "lib/bohu/config_base.rb",
    "lib/bohu/configurable.rb",
    "lib/bohu/delegator.rb",
    "lib/bohu/dot_hash.rb",
    "lib/bohu/dot_hash/behavior.rb",
    "lib/bohu/dsl.rb",
    "lib/bohu/env.rb",
    "lib/bohu/etc.rb",
    "lib/bohu/filesystem.rb",
    "lib/bohu/filesystem/provider.rb",
    "lib/bohu/setup.rb",
    "lib/bohu/shell.rb",
    "lib/bohu/shell/capture.rb",
    "lib/bohu/shell/exceptions.rb",
    "lib/bohu/shell/provider.rb",
    "lib/bohu/shell/result.rb",
    "lib/bohu/utils.rb",
    "lib/bohu/version.rb",
    "lib/bohu/version.yml",
    "lib/bohu/which.rb",
  ]

  
end

# Local Variables:
# mode: ruby
# End:
