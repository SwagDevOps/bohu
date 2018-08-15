# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../bohu'

class Bohu::Config < Bohu::DotHash
  # @param [Hash]
  # @return [Hash]
  def deep_merge(other_hash)
    self.class.__send__(:deep_merge, self.clone.to_h, other_hash.to_h)
  end

  # @param [Hash]
  # @return [self]
  def deep_merge!(other_hash)
    merged = deep_merge(other_hash)

    self.clear.tap do
      merged.each { |k, v| self[k] = v }
    end
  end

  class << self
    protected

    # @param target [Hash] target **altered** hash
    # @param origin [Hash]
    # @return the modified target hash
    #
    # @note this method does not merge Arrays
    def deep_merge(target, origin)
      target.merge!(origin) do |key, oldval, newval|
        hashable = oldval.is_a?(Hash) and newval.is_a?(Hash)

        newval = deep_merge(oldval, newval) if hashable

        newval
      end
    end
  end
end
