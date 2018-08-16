# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../bohu'

# Config with dot access notation.
class Bohu::Command
  autoload :Dialect, "#{__dir__}/command/dialect"
  autoload :Runner, "#{__dir__}/command/runner"

  # @param [Bohu::Config] config
  def initialize(config = Bohu.config)
    @config = config
  end

  # Execute a command.
  #
  # @param [String|Symbol] name command name
  # @param [String|Symbol] action action name
  def call(name, action, **kwargs)
    transform(name, action, **kwargs).tap do |command|
      Runner.new(command).call
    end
  end

  # Build a command using dialect.
  #
  # @param [String|Symbol] name command name
  # @param [String|Symbol] action action name
  # @return [Array<String>]
  def transform(name, action, **kwargs)
    make_cmd(name, action, **kwargs)
  end

  protected

  attr_reader :config

  # @param [String|Symbol] name
  # @param [String|Symbol] action
  # @return [Array<String>]
  def make_cmd(name, action, **kwargs)
    make_args(name, action, **kwargs).tap do |args|
      self.config.commands.public_send(name).tap do |config|
        return [config.executable].push(*args)
      end
    end
  end

  # @param [String|Symbol] name
  # @param [String|Symbol] action
  # @return [Array<String>]
  def make_args(name, action, **kwargs)
    self.config.commands.public_send(name).tap do |config|
      dialect = Dialect.load(name, config.dialect)

      config.actions.public_send(action).tap do |options|
        return dialect.transform(options.merge(kwargs)).map { |s| s % kwargs }
      end
    end
  end
end
