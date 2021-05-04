# frozen_string_literal: true

# Copyright (C) 2017-2021 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../bohu'

# Provide ``find_executable`` method.
#
# @see https://github.com/ruby/ruby/blob/trunk/lib/mkmf.rb#L1586
module Bohu::Which
  autoload :Pathname, 'pathname'

  protected

  # @param [String|Symbol] executable
  # @return [Pathname|nil]
  def find_executable(executable, env_path = ENV['PATH'])
    env_path.split(File::PATH_SEPARATOR).each do |path|
      fp = Pathname.new(path).join(executable.to_s)

      return fp if fp.executable? and fp.file?
    end

    nil
  end
end
