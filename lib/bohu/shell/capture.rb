# frozen_string_literal: true

require_relative '../shell'
require 'English'

# Provide capture methods.
class Bohu::Shell::Capture < Array
  autoload :Open3, 'open3'
  autoload :Result, "#{__dir__}/capture/result"

  # @return [Result]
  def capture
    Result.new(*Open3.capture3(*self))
  end

  # @raise [SystemExit]
  # @return [Capture]
  def capture!
    @mutex_capture ||= Mutex.new

    @mutex_capture.synchronize do
      capture.tap do |res|
        return res if res.success?

        exit(res.exitstatus)
      end
    end
  end
end
