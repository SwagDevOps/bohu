# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../command'

# Command runner.
class Bohu::Command::Runner < Array
  # @return [Bohu::Config|Hash]
  attr_reader :config

  # @param [Array] command
  # @param [Bohu::Config] config
  def initialize(command, config = Bohu.config)
    self.push(*command)

    @config = Bohu::ConfigBase.new(config).clone.freeze
  end

  # @raise [SystemExit]
  def call
    shell.sh(*self)
  end

  protected

  # @return [Bohu::Shell]
  def shell
    Bohu::Shell.new(config)
  end
end
