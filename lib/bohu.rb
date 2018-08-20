# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

$LOAD_PATH.unshift(__dir__)
require "#{__dir__}/bohu/locked"

# Bohu module
module Bohu
  singleton_class.include(self)

  {
    VERSION: :version,
    Config: :config,
    Configurable: :configurable,
    Command: :command,
    Commands: :commands,
    DotHash: :dot_hash,
    Shell: :shell,
    Which: :which,
  }.each do |k, v|
    autoload k, "#{__dir__}/bohu/#{v}"
  end

  # @return [Config]
  def config
    mutex = Mutex.new

    mutex.synchronize { @config ||= Config.new }
  end

  # @raise [SystemExit]
  def sh(*cmd)
    Shell.__send__(:sh, *cmd)
  end
end
