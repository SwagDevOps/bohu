# frozen_string_literal: true

# Copyright (C) 2017-2021 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../filesystem'

# Provide several file utility methods for copying, moving, removing, etc.
#
# @see Bohu::Filesystem
# @see http://ruby-doc.org/stdlib-2.3.0/libdoc/fileutils/rdoc/FileUtils.html
class Bohu::Filesystem::Provider < Bohu::Delegator
  Bohu::Filesystem.tap do |klass|
    forward(*klass.fileutils_methods, to: klass)
  end
end
