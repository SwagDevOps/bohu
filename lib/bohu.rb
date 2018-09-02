# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

$LOAD_PATH.unshift(__dir__)
require "#{__dir__}/bohu/locked"

# Bohu module
module Bohu
  singleton_class.include(self)

  {
    VERSION: :version,
    Config: :config,
    Configurable: :configurable,
    Command: :command,
    Commands: :commands,
    DotHash: :dot_hash,
    Etc: :etc,
    Shell: :shell,
    Utils: :utils,
    Which: :which,
  }.each { |k, v| autoload k, "#{__dir__}/bohu/#{v}" }

  # Get config.
  #
  # @return [Config]
  def config
    {
      filepath: ENV['BOHU_CONFIG'],
      load_defaults: !!ENV['BOHU_CONFIG_LOAD_DEFAULTS'],
    }.tap { |kwargs| config_load(kwargs) if @config.nil? }

    @config
  end

  # Load config for given filepath.
  #
  # @return [Config]
  def config_load(filepath: nil, load_defaults: true)
    (@config_mutex ||= Mutex.new).synchronize do
      @config = Config.new(filepath, load_defaults: load_defaults)
    end
  end

  # @see #instance_for
  def method_missing(method, *args, &block)
    return super unless respond_to_missing?(method)

    return instance_for(method).public_send(method, *args, &block)
  end

  # @see #instance_for
  def respond_to_missing?(method, include_private = false)
    instance_for(method).nil? ? super : true
  end

  protected

  # Get instance for given method.
  #
  # @return [Object|nil]
  def instance_for(method)
    callables.each do |func|
      func.call.tap do |instance|
        return instance if instance.respond_to?(method)
      end
    end

    nil
  end

  # Get callables.
  #
  # @return [Array<Proc>]
  def callables
    [Commands::Shell, Etc, Utils].map do |klass|
      -> { klass.new(config) }
    end
  end
end
