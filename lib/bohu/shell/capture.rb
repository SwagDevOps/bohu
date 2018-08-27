# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

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
