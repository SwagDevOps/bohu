# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../commands'

# @bastract
class Bohu::Commands::BaseCommand
  include Bohu::Configurable

  # @see Bohu::Configurable.initialize
  def initialize(*args)
    @config_root = self.class.__send__(:config_root)

    super(*args)
  end

  def method_missing(method, *args, &block)
    return super unless respond_to_missing?(method)

    self.class.command(method).prepare(*args).call
  end

  def respond_to_missing?(method, include_private = false)
    self.class.command(method).preparable? || super(method, include_private)
  end

  class << self
    # @param [String|Symbol] action
    #
    # @return [Bohu::Command]
    def command(action)
      config_root.split('.').fetch(-1).to_sym.tap do |name|
        return Bohu::Command.new(name, action)
      end
    end

    protected

    # @return [String]
    def config_root
      self.name.split('::')[-2..-1].map { |w| underscore(w) }.join('.')
    end

    # Underscore given word
    #
    # @param [String] word
    # @return [String]
    def underscore(word)
      word.to_s
          .gsub(/::/, '/')
          .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
          .gsub(/([a-z\d])([A-Z])/, '\1_\2')
          .tr('-', '_')
          .downcase
    end
  end
end
