# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../commands'

# Provide access to class and methods defined by commands.
#
# Sample of use:
#
# ```yaml
# commands:
#  usermod:
#     actions:
#       change_shell:
#         login_shell: '%<login_shell>s'
#         login: '%<login>s'
# ```
#
# ```ruby
# Provider.new.call(:usermod)
# # [Bohu::Commands::Usermod]
# Provider.new.call(:change_shell, login: 'root', login_shell: '/bin/bash')
# # true
# ```
class Bohu::Commands::Provider
  include Bohu::Configurable

  Loader = Bohu::Commands::Loader

  # @param [String|Symbol] sym
  def call(sym, *args, &block)
    stt(sym).compact.each do |v|
      return v.call(*args, &block)
    end
  end

  # Denote method or class (underscore notation) is provided.
  #
  # @param [Symbol|String] sym
  # @return [Boolean]
  def provide?(sym)
    stt(sym).map { |v| !!v }
            .tap { |stt| return true if stt.include?(true) }

    false
  end

  # Find class for given method.
  #
  # @param [Symbol|String] method
  # @return [Class|nil]
  def class_for(method)
    config[:commands].each do |k, v|
      next unless v[:actions].to_h.key?(method.to_sym)

      return loader.load!(k)
    end

    nil
  end

  # Denote method is provided.
  #
  # @param [Symbol|String] method
  # @return [Boolean]
  def method?(method)
    !!class_for(method)
  end

  protected

  def config_root
    nil
  end

  # Get callables.
  #
  # @param [Symbol|String] sym
  # @return [Array<Method|nil>]
  def stt(sym)
    [
      loader.loadable?(sym) ? loader.load!(sym).method(:new) : nil,
      method?(sym) ? class_for(sym).new.method(sym) : nil
    ].freeze
  end

  # @return [Bohu::Commands::Loader]
  def loader
    Loader.new(config)
  end
end
