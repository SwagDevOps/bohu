# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

$LOAD_PATH.unshift(__dir__)

# Bohu module
#
# @see Bohu::Shell
# @see Bohu::Commands::Shell
# @see Bohu::Etc
# @see Bohu::Filesystem
module Bohu
  singleton_class.include(self)

  {
    VERSION: :version,
    Bundleable: :bundleable,
    Config: :config,
    Configurable: :configurable,
    Delegator: :delegator,
    Command: :command,
    Commands: :commands,
    DotHash: :dot_hash,
    Env: :env,
    Etc: :etc,
    Filesystem: :filesystem,
    Shell: :shell,
    Which: :which,
  }.each { |k, v| autoload k, "#{__dir__}/bohu/#{v}" }

  # Get a read-only env representation.
  #
  # @return [Hash, Bohu::Env]
  def env
    Env.new.freeze
  end

  include(Bundleable) unless env['BOHU_BUNDLED'] == false

  # Get config.
  #
  # @return [Config]
  def config
    unless @config
      self.env.tap do |env|
        configure(env['BOHU_CONFIG'], load_defaults: !!env['BOHU_DEFAULTS'])
      end
    end

    @config
  end

  # Load config for given filepath.
  #
  # @param [String, Hash, nil] config
  # @param [Boolean] load_defaults
  # @return [self]
  #
  # @see Bohu::Config
  def configure(config = nil, load_defaults: true)
    self.tap do
      (@config_mutex ||= Mutex.new).synchronize do
        @config = Bohu::Config.new(config, load_defaults: load_defaults)
      end
    end
  end

  # @see #instance_for
  def method_missing(method, *args, &block)
    return super unless respond_to_missing?(method)

    instance_for(method).public_send(method, *args, &block)
  end

  # @see #instance_for
  def respond_to_missing?(method, include_private = false)
    instance_for(method).nil? ? super : true
  end

  protected

  # Get instance for given method.
  #
  # @return [Object, nil]
  def instance_for(method)
    nil.tap do
      callables.each do |func|
        func.call.tap do |instance|
          return instance if instance.respond_to?(method)
        end
      end
    end
  end

  # Get callables.
  #
  # @return [Array<Proc>]
  def callables
    [
      Shell::Provider,
      Commands::Shell,
      Etc,
      Filesystem::Provider
    ].map { |klass| -> { klass.new(config) } }
  end
end
