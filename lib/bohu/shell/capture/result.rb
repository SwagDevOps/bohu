# frozen_string_literal: true

require_relative '../capture'

# Capture result.
class Bohu::Shell::Capture::Result
  # @return [String]
  attr_reader :stdout

  # @return [String]
  attr_reader :stderr

  # @return [Process::Status]
  attr_reader :status

  # @param [String] stdout
  # @param [String] stderr
  # @param [Process::Status] status
  def initialize(stdout, stderr, status)
    @stdout = stdout
    @stderr = stderr
    @status = status
  end

  # @return [Boolean]
  def success?
    exitstatus.zero?
  end

  # @return [Boolean]
  def failure?
    !success?
  end

  # @return [Integer]
  def exitstatus
    status.exitstatus
  end
end
