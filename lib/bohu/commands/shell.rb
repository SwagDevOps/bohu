# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../commands'

# Shell provides access to user defined methods.
class Bohu::Commands::Shell
  include Bohu::Configurable

  # @api
  Callable = Bohu::Commands::Callable

  def initialize(*)
    @config_root = nil

    super
  end

  def method_missing(method, *args, &block)
    return super unless respond_to_missing?(method)

    return Callable.new(config_base).call(method, *args, &block)
  end

  def respond_to_missing?(method, include_private = false)
    Callable.new(config_base).callable?(method) ? true : super
  end

  # @return [Array<Symbol>]
  def public_methods
    config[:commands]
      .to_a
      .map { |k, v| v[:actions].keys }
      .flatten.sort.tap { |commands| return super + commands }
  end
end
