# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../commands'

# Provide class loading and definition, based on config.
#
# Sample of use:
#
# ```yaml
# commands:
#  usermod:
#     actions:
#       change_shell:
#         login_shell: '%<login_shell>s'
#         login: '%<login>s'
# ```
#
# ```ruby
# Loader.new.load!(:usermod)
# # Bohu::Commands::Usermod
# Loader.new.load
# # [Bohu::Commands::Usermod]
# ```
class Bohu::Commands::Loader
  include Bohu::Configurable

  # Get module for loaded classes.
  #
  # @return [Bohu::Commands::Loaded]
  def container
    Bohu::Commands::Loaded
  end

  # Load all defined commands.
  #
  # @return [Array<Class>]
  def load
    config[:commands].keys.sort.map { |k| load!(k) }
  end

  # Load class by (underscore notation) given name.
  #
  # @raise [NameError]
  #
  # @param [String|Symbol] name
  # @return [Bohu::Commands::BaseCommand]
  def load!(name)
    self.class.__send__(:camelize, name.to_s).tap do |class_name|
      "#{container}::#{class_name}".tap do |class_const|
        if loadable?(name) and !Object.const_defined?(class_const)
          container
            .const_set(class_name, Class.new(Bohu::Commands::BaseCommand))
        end

        return Object.const_get(class_const)
      end
    end
  end

  # @param [String|Symbol] name
  #
  # @return [Boolean]
  def loadable?(name)
    config[:commands].key?(name.to_sym)
  end

  protected

  def config_root
    nil
  end

  class << self
    protected

    def camelize(word)
      word.split('_').collect(&:capitalize).join
    end
  end
end
