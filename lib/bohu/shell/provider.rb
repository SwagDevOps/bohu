# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../shell'

# Shell provider.
#
# Almost a wrapper restricting access to some methods.
class Bohu::Shell::Provider < Bohu::Delegator
  forward(Bohu::Shell, :sh, :capture, :capture!)
end
