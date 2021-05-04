# frozen_string_literal: true

# Copyright (C) 2017-2021 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../bohu'

# Config with dot access notation.
#
# @abstract
class Bohu::ConfigBase < Bohu::DotHash
  # @param [Hash|nil] input
  def initialize(input = nil)
    super

    return if input.nil?

    self.clear
    self.class.__send__(:symbolize_keys, input).each { |k, v| self[k] = v }
  end

  # @param [Hash] other_hash
  # @return [Hash]
  def deep_merge(other_hash)
    other_hash = self.class.new(other_hash)

    self.class.__send__(:deep_merge, self.clone.to_h, other_hash.to_h)
  end

  # @param [Hash] other_hash
  # @return [self]
  def deep_merge!(other_hash)
    merged = deep_merge(other_hash)

    self.clear.tap do
      merged.each { |k, v| self[k] = v }
    end
  end

  class << self
    autoload :JSON, 'json'

    protected

    # @param target [Hash] target **altered** hash
    # @param origin [Hash]
    # @return [Hash] modified target hash
    #
    # @note this method does not merge Arrays
    def deep_merge(target, origin)
      target.merge!(origin) do |key, oldval, newval|
        hashable = oldval.is_a?(Hash) and newval.is_a?(Hash)

        newval = deep_merge(oldval, newval) if hashable

        newval
      end
    end

    # Recursively transform keys to symbol
    #
    # @param [Hash] input
    # @return [Hash{Symbol => Object}]
    def symbolize_keys(input)
      JSON.parse(JSON.dump(input.to_hash), symbolize_names: true)
    end
  end
end
