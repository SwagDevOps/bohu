# frozen_string_literal: true

require_relative '../shell'

# @abstract
class Bohu::Shell::CommandLineError < StandardError
  # @return [String]
  attr_reader :command

  autoload :Shellwords, 'shellwords'

  # @param [Array<String>|String] command
  def initialize(command)
    @command = command
  end

  # @return [String]
  def to_s
    "\"#{command}\""
  end

  protected

  # @param [Array<String>|String] command
  def command=(command)
    @command = command.is_a?(Array) ? Shellwords.join(command) : command
  end
end

# Error used when exitstatus is non zero.
class Bohu::Shell::ExitStatusError < Bohu::Shell::CommandLineError
  # @return [Process::Status|Object|nil]
  attr_reader :result

  # @param [Array<String>|String] command
  # @param [Process::Status|Object|nil] result
  def initialize(command, result = nil)
    super(command)

    self.result = result unless result.nil?
  end

  # @return [String]
  def to_s
    return super if result.nil?

    "#{super} exited with status: #{result.exitstatus}"
  end

  protected

  # @raise [TypeError]
  # @param [Process::Status|Object] result
  def result=(result)
    unless result.respond_to?(:exitstatus)
      raise TypeError, "#{result.class} must respond to: exitstatus"
    end

    @result = result
  end
end
