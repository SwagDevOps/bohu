# frozen_string_literal: true

require_relative 'lib/bohu'
require 'bohu'
require 'sys/proc'

Sys::Proc.progname = nil

Kamaze.project do |project|
  project.subject = Bohu
  project.name    = 'bohu'
  project.tasks   = [
    'cs:correct', 'cs:control', 'cs:pre-commit',
    'doc', 'doc:watch',
    'gem', 'gem:install', 'gem:compile',
    'misc:gitignore',
    'shell', 'sources:license', 'test', 'version:edit',
  ]
end.load!

task default: [:gem]

if project.path('spec').directory?
  task :spec do |task, args|
    Rake::Task[:test].invoke(*args.to_a)
  end
end
