# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../bohu'

# Use dot syntax with Ruby hashes.
class Bohu::DotHash < Hash
  require_relative 'dot_hash/behavior'
  include Behavior

  # @raise [TypeError]
  # @param [Hash] input
  def initialize(input = nil)
    (input.nil? ? {} : input).tap do |h|
      unless h.respond_to?(:to_hash)
        raise TypeError, "no implicit conversion of #{input.class} into Hash"
      end

      h.to_hash.each { |k, v| self[k] = v }
    end
  end
end
