# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../bohu'

# Env wrapper.
class Bohu::Env < Hash
  autoload :YAML, 'yaml'

  # @param [Hash|nil] env
  def initialize(env = nil)
    (env || ::ENV).clone.to_h.sort.to_h.each { |k, v| safe_load(k, v) }
  end

  protected

  # Load value as YAML.
  def safe_load(key, val)
    self[key] = YAML.safe_load(val)
  rescue RuntimeError # Psych::DisallowedClass, Psych::SyntaxError
    self[key] = val
  end
end
