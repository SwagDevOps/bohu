# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../bohu'
require_relative 'config_base'

# Config with dot access notation.
class Bohu::Config < Bohu::ConfigBase
  autoload :YAML, 'yaml'
  autoload :Pathname, 'pathname'

  def initialize(filepath = nil)
    (filepath || "#{__dir__}/config.yml").tap do |fp|
      Pathname.new(fp).read.tap do |content|
        YAML.safe_load(content, [Symbol]).tap do |parsed|
          super(parsed)
        end
      end
    end
  end
end
