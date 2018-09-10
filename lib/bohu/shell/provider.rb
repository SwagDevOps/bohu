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
  # @!method sh
  #   @return [Bohu::Shell::Result] See {Bohu::Shell#sh}.
  # @!method capture
  #   @return [Bohu::Shell::Result] See {Bohu::Shell#capture}.
  # @!method capture!
  #   @return [Bohu::Shell::Result] See {Bohu::Shell#capture!}.
  forward(:sh, :capture, :capture!, to: Bohu::Shell)
end
