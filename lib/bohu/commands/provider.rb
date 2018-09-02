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
# Provider.new.call(:change_shell, login: 'root', login_shell: '/bin/bash')
# ```
class Bohu::Commands::Provider
  include Bohu::Configurable

  Loader = Bohu::Commands::Loader

  # @param [String|Symbol] sym
  def call(sym, *args, &block)
    callable_for(sym).call(*args, &block)
  end

  # Denote method is callable.
  #
  # @param [Symbol|String] sym
  # @return [Boolean]
  def callable?(sym)
    callable_for(sym).nil? == false
  end

  protected

  def config_root
    nil
  end

  # Find class for given method.
  #
  # @param [Symbol|String] method
  # @return [Class|nil]
  def class_for(method)
    (config[:commands] || {}).each do |k, v|
      next unless v[:actions].to_h.key?(method.to_sym)

      return loader.load!(k)
    end

    nil
  end

  # Get callable for given symbol (method).
  #
  # @param [Symbol|String] sym
  # @return [Method|nil]
  def callable_for(sym)
    class_for(sym).tap do |klass|
      return klass ? klass.new.method(sym) : nil
    end
  end

  # @return [Bohu::Commands::Loader]
  def loader
    Loader.new(config)
  end
end
