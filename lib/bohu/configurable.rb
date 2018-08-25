# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../bohu'

# Configurable behavior.
module Bohu::Configurable
  singleton_class.include(self)

  # @return [Bohu::ConfigBase]
  attr_reader :config

  # @param [Bohu::Config|Hash|nil] config
  def initialize(config = nil)
    (config.nil? ? Bohu.config : config).freeze.tap do |c|
      @config_base = Bohu::ConfigBase.new(c)
      @config = @config_base.clone

      config_root.to_s.split('.').each do |m|
        @config = @config.class.new(@config.public_send(m))
      end
      @config.freeze
    end
  end

  class << self
    define_method(:new) do |*args|
      ::Class.new { include Bohu::Configurable }.new(*args)
    end
  end

  protected

  # Get base config.
  #
  # @return [Bohu::ConfigBase]
  attr_reader :config_base

  # Get root config key.
  #
  # @return [String|nil]
  def config_root
    return @config_root if @config_root
    return nil unless self.class.name

    self.class.name.split('::')[1..-1].map(&:to_s).map do |word|
      word.gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
          .gsub(/([a-z\d])([A-Z])/, '\1_\2')
          .tr('-', '_').downcase
    end.join('.')
  end
end
