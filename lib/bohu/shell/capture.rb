# frozen_string_literal: true

require_relative '../shell'
require 'English'

# Provide capture methods.
class Bohu::Shell::Capture < Array
  autoload :Open3, 'open3'

  Result = Bohu::Shell::Result
  ExitStatusError = Bohu::Shell::ExitStatusError

  # @return [Result]
  def capture
    Open3.capture3(*self).tap do |res|
      return Result.new(res.fetch(2), res.fetch(0), res.fetch(1))
    end
  end

  # @raise [ExitStatusError]
  # @return [Capture]
  def capture!
    return capture.tap do |result|
      unless result.success?
        raise ExitStatusError.new(self, result)
      end
    end
  end
end
