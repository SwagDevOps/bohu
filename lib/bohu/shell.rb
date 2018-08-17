# frozen_string_literal: true

require_relative '../bohu'
require 'English'

# Provide shell.
#
# @see Bohu.sh
class Bohu::Shell
  autoload :Shellwords, 'shellwords'

  include Bohu::Configurable

  # @raise [SystemExit]
  # @return [Boolean]
  def sh(*args)
    mutex = Mutex.new

    parse_args(*args).tap do |command|
      warn("# #{Shellwords.join(command)}") if verbose?

      mutex.synchronize do
        return system(*command).tap do |res|
          exit($CHILD_STATUS.exitstatus) unless res
        end
      end
    end
  end

  # Denote shell verbosity.
  #
  # @return [Boolean]
  def verbose?
    @verbose.nil? ? config[:verbose] : @verbose
  end

  # Set verbosity.
  #
  # @param [Boolean] verbose
  def verbose=(verbose)
    @verbose = !!verbose
  end

  protected

  # @return [Array<String>]
  def parse_args(*args)
    (args.size == 1 ? Shellwords.split(args[0]) : args)
      .compact
      .map(&:to_s)
  end
end
