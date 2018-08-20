# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../bohu'

# Command using dialect.
#
# A command is defined by a ``name`` and an ``action``.
#
# Samples of use:
#
# ```ruby
# Command.new('adduser', :create_user)
#        .call(system: false, login: 'user_name', login_shell: '/bin/bash')
#
# Command.new('adduser', :create_user)
#        .prepare(system: false, login: 'user_name', login_shell: '/bin/bash')
#        .call
# ```
#
# ## Configuration
#
# Sample config:
#
# ```yaml
# commands:
#   adduser:
#     dialect: default
#     executable: adduser
# ```
#
# ``dialect`` is optional, allowing to choose dialect used to transform
# command into a command line.
#
# ``executable`` is optional, otherwise ``name`` is used, and resolved
# in an UNIX ``which`` similar manner.
class Bohu::Command < Array
  include Bohu::Configurable
  include Bohu::Which

  autoload :Runner, "#{__dir__}/command/runner"
  autoload :Dialect, "#{__dir__}/command/dialect"

  # Get command name
  attr_reader :name

  # Get action name
  attr_reader :action

  # @param [String|Symbol] name
  # @param [String|Symbol] action
  # @param [Bohu::Config|nil] config
  def initialize(name, action, config = nil)
    @name = name.to_sym
    @action = action.to_sym

    # configurable use ``commands`` as root key
    (@config_root = :commands).tap { super(*[config].compact) }
  end

  # Get executable
  #
  # @return [Pathname|Symbol|String]
  def executable
    executable = config[:executable] || name

    find_executable(executable) || executable
  end

  # @return [Boolean]
  def executable?
    !!find_executable(executable)
  end

  # Denote command can be prepared.
  #
  # @return [Boolean]
  def preparable?
    !actions_config[:action].nil?
  end

  # Prepare command.
  #
  # @param [Hash] options
  # @return [self]
  def prepare(options = {})
    self.clear.tap do
      options
        .map { |k, v| [k, [true, false].include?(v) ? v : v.to_s] }
        .to_h.tap do |kwargs|
        self.make_cmd(kwargs).each_with_index { |v, k| self[k] = v }
      end
    end
  end

  def call(options = nil)
    self.clone.tap do |command|
      command.prepare(options) if options or self.empty?

      return Runner.new(command).call
    end
  end

  protected

  # @return [Dialect]
  def dialect
    config.public_send(name).tap do |config|
      return @dialect ||= Dialect.load(name, config[:dialect] || :default)
    end
  end

  # @todo better error handling
  #
  # @return [Bohu::DotHash]
  def actions_config
    config.public_send(name).actions
  end

  # @todo better error handling
  #
  # @return [Bohu::DotHash]
  def action_config
    actions_config.public_send(action)
  end

  # Build a command using dialect.
  #
  # @return [Array<String>]
  def make_cmd(**kwargs)
    make_args(**kwargs).tap do |args|
      config.public_send(name).tap do |config|
        return [executable.to_s].push(*args)
      end
    end
  end

  # @return [Array<String>]
  def make_args(**kwargs)
    options = make_options(**kwargs)

    dialect.transform(options.merge(kwargs)).map do |s|
      begin
        s % kwargs
      rescue KeyError => e
        raise ArgumentError, "missing keyword: #{e.key}"
      end
    end
  end

  # @return [Hash]
  def make_options(**kwargs)
    action_config.map do |k, v|
      if v.is_a?(Array)
        [k, kwargs.key?(k) ? v[0] : v[1]]
      else
        [k, v]
      end
    end.to_h
  end
end
