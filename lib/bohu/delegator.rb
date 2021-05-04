# frozen_string_literal: true

# Copyright (C) 2017-2021 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../bohu'
require 'forwardable'

# Delegator
#
# @abstract
# @see https://ruby-doc.org/stdlib-2.3.0/libdoc/forwardable/rdoc/Forwardable.html
class Bohu::Delegator
  extend ::Forwardable
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

    # Sample of use:
    #
    # ```ruby
    # class Foo
    #   forward(:answer, :do_something, to: Bar)
    # end
    # ```
    #
    # @param [Array<Symbol|String>] methods
    # @return [self]
    def forward(*methods, **kwargs)
      kwargs.fetch(:to).tap do |klass|
        self.delegator_class = klass

        def_delegators(*([:@delegator] + methods.map(&:to_sym)))
      end

      self
    end
  end

  @delegator_class = nil
end
