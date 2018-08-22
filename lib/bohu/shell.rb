# frozen_string_literal: true

require_relative '../bohu'
require 'English'

# Provide shell.
#
# @see Bohu.sh
class Bohu::Shell
  autoload :Shellwords, 'shellwords'

  include Bohu::Configurable

  autoload :Capture, "#{__dir__}/shell/capture"

  # @raise [SystemExit]
  # @return [Boolean]
  def sh(*args)
    @mutex_sh ||= Mutex.new

    parse_args(*args).tap do |command|
      warn(Shellwords.join(command)) if verbose?

      @mutex_sh.synchronize do
        return system(*command).tap do |res|
          exit($CHILD_STATUS.exitstatus) unless res
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
