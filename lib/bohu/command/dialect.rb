# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../command'

# Config with dot access notation.
class Bohu::Command::Dialect < Hash
  autoload :Pathname, 'pathname'
  autoload :YAML, 'yaml'

  # @param [Hash] dict
  # @param [Bohu::Config|Hash|nil] config
  def initialize(dict)
    self.class.__send__(:symbolize_keys, dict || {}).each do |k, v|
      self[k] = v
    end
  end

  # Transform given hash.
  #
  # @param [Hash] input
  # @return [Array<String>]
  def transform(input)
    [].tap do |output|
      self.class.__send__(:symbolize_keys, input).each do |k, v|
        if self.key?(k)
          process_option(k, v, input).tap { |words| output.push(*words) }
        else
          output.push(v.to_s % input)
        end
      end
    end
  end

  protected

  # Translate given option to dialect.
  #
  # @param [Symbol] name
  # @param [Boolean|String] value
  # @param [Hash] input
  #
  # @return [Array<String>|nil]
  def process_option(name, value, input = {})
    trans = self.fetch(name)
    vbool = [true, false].include?(trans[1])

    return [trans[0], trans[1] % input] unless vbool
    return [trans[0]] if value == trans[1]
  end

  class << self
    # Load a dialect for given command and type.
    #
    # @param [String|Symbol] command name
    # @param [String|Symbol] type name, example: ``default``
    # @param [Bohu::Config] config
    # @return [self]
    def load(command, type, config = nil)
      paths = self.paths(config)

      paths.each do |path|
        begin
          path.join(*[type, command].map(&:to_s)).tap do |fname|
            return file("#{fname}.yml")
          end
        rescue Errno::ENOENT => e
          raise e if path == paths.last
        end
      end
    end

    # Get paths.
    #
    # @param [Bohu::Config] config
    # @return [Array<Pathname>]
    def paths(config = nil)
      config ||= Bohu.config

      [].tap do |paths|
        (config.fetch(:dialects, {})[:paths] || [])
          .map { |path| Pathname.new(path) }
          .map { |fp| fp.absolute? ? fp : Pathname.new(Dir.pwd).join(fp) }
          .each { |path| paths.push(path) }
      end.push(default_path)
    end

    # Load a file by given filepath.
    #
    # @param [String] filepath
    # @raise [Errno::ENOENT]
    # @return [self]
    def file(filepath)
      Pathname.new(filepath.to_s).realpath.read.tap do |content|
        return self.new(YAML.safe_load(content))
      end
    end

    # Get default path.
    #
    # @return [Pathname]
    def default_path
      Pathname.new("#{__dir__}/../dialects").realpath
    end

    protected

    # Returns a new hash with all keys converted to symbols.
    #
    # @param [Hash] input
    # @return [Hash]
    def symbolize_keys(input)
      Hash[input.map { |(k, v)| [k.to_s.to_sym, v] }]
    end
  end
end
