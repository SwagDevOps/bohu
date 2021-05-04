# frozen_string_literal: true

# Copyright (C) 2017-2021 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../bohu'

# Provide commands.
module Bohu::Commands
  autoload :BaseCommand, "#{__dir__}/commands/base_command"
  autoload :Loader, "#{__dir__}/commands/loader"
  autoload :Callable, "#{__dir__}/commands/callable"
  autoload :Shell, "#{__dir__}/commands/shell"

  # Module for user loaded classes.
  module Loaded
  end
end
