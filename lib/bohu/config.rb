# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../bohu'
require_relative 'config_base'

# Config with dot access notation.
#
# Config is loaded from a given filepath and merged recursively with defaults.
class Bohu::Config < Bohu::ConfigBase
  autoload :YAML, 'yaml'
  autoload :Pathname, 'pathname'

  # Load config by given filepath (or use defaults).
  #
  # @param [String] filepath
  def initialize(filepath = nil)
    # for internal use, as deep_merge methods use initialize
    filepath.tap { |input| return super(input) if input.is_a?(Hash) }

    super(self.class.defaults).tap do
      return unless filepath

      self.safe_load(filepath)
          .tap { |parsed| self.deep_merge!(parsed) }
    end
  end

  protected

  # @see Config.safe_load
  #
  # @param [String] filepath
  # @return [Hash]
  def safe_load(filepath)
    self.class.__send__(:safe_load, filepath)
  end

  class << self
    # Get defaults.
    #
    # @return [Hash]
    def defaults
      self.safe_load("#{__dir__}/config.yml")
    end

    protected

    # Load given YAML file.
    #
    # @param [String] filepath
    # @return [Hash]
    def safe_load(filepath)
      Pathname.new(filepath)
              .read
              .tap { |content| return YAML.safe_load(content, [Symbol]) }
    end
  end
end
