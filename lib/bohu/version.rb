# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../bohu'

# Describe version using a YAML file.
#
# @see https://github.com/jcangas/version_info
class Bohu::Version
  autoload :Pathname, 'pathname'
  autoload :Yaml, 'yaml'

  # Get filepath used to parse version (YAML file).
  #
  # @return [Pathname|String]
  attr_reader :file

  # @param [String|Pathname|nil] file
  def initialize(file = nil)
    (file.nil? ? file_from(caller_locations) : file).tap do |fp|
      @file = ::Pathname.new(fp).freeze
    end

    parse!
  end

  # Denote version is semantically valid
  #
  # @return [Boolean]
  def valid?
    !!(/^([0-9]+\.){2}[0-9]+$/ =~ self.to_s)
  rescue ::NameError
    false
  end

  # @raise [NameError]
  # @return [String]
  def to_s
    [major, minor, patch].map(&:to_i).join('.')
  end

  # @return [Hash]
  def to_h
    parsed.clone.freeze
  end

  # Return the path as a String.
  #
  # @see https://ruby-doc.org/stdlib-2.5.0/libdoc/pathname/rdoc/Pathname.html#method-i-to_path
  # @return [String]
  def to_path
    file.to_s
  end

  protected

  # Get parsed data
  #
  # @return [Hash]
  attr_reader :parsed

  # Get file automagically
  #
  # @param [Array] locations
  # @return [Pathname]
  def file_from(locations = caller_locations)
    location = locations.first.path

    Pathname.new(location).dirname.realpath.join('version.yml')
  end

  # Parse given file
  #
  # @param [Pathname] file
  # @raise [Psych::DisallowedClass]
  # @return [Hash]
  def parse(file)
    YAML.safe_load(file.read) || {}
  rescue Errno::ENOENT
    {}
  end

  # Parse and set attributes
  #
  # @return [self]
  def parse!
    @parsed = self.parse(self.file)
                  .map { |k, v| self.attr_set(k, v) }
                  .compact
                  .to_h

    self
  end

  # Define attribute (as ``ro`` attr) and set value.
  #
  # @param [String|Symbol] attr_name
  # @param [Object] attr_value
  # @return [Array|nil]
  def attr_set(attr_name, attr_value)
    attr_name = self.class.__send__(:underscore, attr_name.to_s)

    return nil unless eligible_attr?(attr_name)

    self.singleton_class.class_eval do
      attr_accessor attr_name
      # rubocop:disable Style/AccessModifierDeclarations
      protected "#{attr_name}="
      # rubocop:enable Style/AccessModifierDeclarations
    end

    self.__send__("#{attr_name}=", attr_value.freeze)

    [attr_name, attr_value.freeze].freeze
  end

  # Denote given attr name is eligible (to be set)
  #
  # @param [String|Symbol] attr_name
  # @return [Boolean]
  def eligible_attr?(attr_name)
    [attr_name, "#{attr_name}="].each do |v|
      return false if self.respond_to?(v, true)
    end

    true
  end

  class << self
    protected

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

unless Bohu.const_defined?(:VERSION)
  Bohu::VERSION = Bohu::Version.new.freeze
end
