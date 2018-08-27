# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../bohu'
require 'English'

# Provide shell.
#
# @see Bohu.sh
class Bohu::Shell
  autoload :Shellwords, 'shellwords'

  include Bohu::Configurable

  autoload :Capture, "#{__dir__}/shell/capture"
  autoload :Result, "#{__dir__}/shell/result"
  autoload :ExitStatusError, "#{__dir__}/shell/exceptions"

  # @raise [ExitStatusError]
  # @return [Boolean]
  def sh(*args)
    self.class.__send__(:mutex).synchronize do
      parse_args(*args).tap do |command|
        warn(Shellwords.join(command)) if verbose?

        system(*command).tap do |b|
          return Result.new($CHILD_STATUS).tap do |result|
            raise ExitStatusError.new(command, result) unless b
          end
        end
      end
    end
  end

  # @return [Capture::Capture]
  def capture(*args)
    capturable(*args).capture
  end

  # @return [Capture::Capture]
  def capture!(*args)
    capturable(*args).capture!
  end

  # Denote shell verbosity.
  #
  # @return [Boolean]
  def verbose?
    return @verbose unless @verbose.nil?
    return true unless config.key?(:verbose)
    !!config[:verbose]
  end

  # Set verbosity.
  #
  # @param [Boolean] verbose
  def verbose=(verbose)
    @verbose = !!verbose
  end

  (@mutex = Mutex.new).tap do
    class << self
      protected

      attr_accessor :mutex
    end
  end

  protected

  # @return [Array<String>]
  def parse_args(*args)
    (args.size == 1 ? Shellwords.split(args[0]) : args)
      .compact
      .map(&:to_s)
  end

  # @return [Capture]
  def capturable(*args)
    Capture.new(parse_args(*args))
  end
end
