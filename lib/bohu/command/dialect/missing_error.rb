# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../dialect'

# Describe a missing dialect error.
class Bohu::Command::Dialect::MissingError < RuntimeError
  # @param [String] command
  # @param [String] type
  def initialize(command, type)
    @command = command
    @type = type
  end

  # Get cause.
  #
  # @return [String]
  def cause
    "#{type}/#{command}"
  end

  # @return [String]
  def to_s
    "No such dialect - #{cause}"
  end

  protected

  # @return [String]
  attr_reader :command

  # @return [String]
  attr_reader :type
end
