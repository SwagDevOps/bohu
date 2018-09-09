# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../bohu'

# Delegator
#
# @abstract
# @see https://ruby-doc.org/stdlib-2.3.0/libdoc/forwardable/rdoc/Forwardable.html
class Bohu::Delegator
  extend Forwardable
  include Bohu::Configurable

  # @see Bohu::Configurable#initialize
  def initialize(*)
    @config_root = nil
    super

    @delegator = self.class.delegator_class.new(config_base)
  end

  class << self
    # @return [[Class|nil]
    attr_accessor :delegator_class

    # @param [Class] klass
    # @param [Array<Symbol|String>] methods
    def forward(klass, *methods)
      self.delegator_class = klass

      def_delegators(*([:@delegator] + methods.map(&:to_sym)))
    end
  end

  @delegator_class = nil
end
