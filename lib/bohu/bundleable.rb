# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

# rubocop:disable Style/Documentation

require_relative '../bohu'

# @see https://github.com/SwagDevOps/stibium-bundled
module Bohu::Bundleable
  autoload(:Pathname, 'pathname')
  autoload(:RbConfig, 'rbconfig')

  BUNDLE_RELATIVE_PATH = '..'

  class << self
    private

    def included(othermod)
      # noinspection RubyNilAnalysis
      self.apply(othermod, from_file: caller_locations.fetch(0).path)
    end

    protected

    # @api private
    #
    # @param from_file [String]
    # @param othermod [Class, Module]
    #
    # @return [Class, Module]
    def apply(othermod, from_file:)
      # noinspection RubyResolve
      Pathname.new(from_file).dirname.join(BUNDLE_RELATIVE_PATH).expand_path.freeze.yield_self do |basedir|
        othermod
          .tap { self.loader.call(basedir) }
          .__send__(:include, ::Stibium::Bundled)
          .__send__(:bundled_from, basedir, setup: true, &bundle_handler)
      end
    end

    # @api private
    #
    # @return [Proc]
    def bundle_handler
      # @type [Stibium::Bundled::Bundle] bundle
      lambda do |bundle|
        if bundle.locked? and bundle.installed? and Object.const_defined?(:Gem)
          # noinspection RubyResolve
          # rubocop:disable Style/SoleNestedConditional
          if bundle.specifications.keep_if { |s| s.name == 'kamaze-project' }.any?
            # noinspection RubyResolve
            require 'kamaze/project/core_ext/pp'
          end
          # rubocop:enable Style/SoleNestedConditional
        end
      end
    end

    # @api private
    #
    # @return [Proc]
    def loader
      # @type [String, Pathname] basedir
      lambda do |basedir|
        [
          [RUBY_ENGINE, RbConfig::CONFIG.fetch('ruby_version'), 'bundler/gems/*/stibium-bundled.gemspec'],
          [RUBY_ENGINE, RbConfig::CONFIG.fetch('ruby_version'), 'gems/stibium-bundled-*/lib/'],
        ].map { |parts| Pathname.new(basedir).join(*['{**/,}bundle'].concat(parts)) }.yield_self do |patterns|
          # noinspection RubyResolve
          Pathname.glob(patterns).first&.dirname&.tap { |gem_dir| require gem_dir.join('lib/stibium/bundled') }
        end
      end
    end
  end
end
