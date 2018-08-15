# frozen_string_literal: true

require_relative '../bohu'
require 'English'

# Provide sh method.
module Bohu::Shell
  autoload :Shellwords, 'shellwords'

  singleton_class.include(self)

  protected

  # @raise [SystemExit]
  def sh(*cmd)
    mutex = Mutex.new

    cmd.compact.map(&:to_s).tap do |command|
      warn(command.size == 1 ? command : Shellwords.join(command))

      mutex.synchronize do
        system(*command)
          .tap { |res| exit($CHILD_STATUS.exitstatus) unless res }
      end
    end
  end
end
