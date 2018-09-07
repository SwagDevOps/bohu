# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../bohu'
require 'fileutils'

# Provide several file utility methods for copying, moving, removing, etc.
class Bohu::Filesystem
  include Bohu::Configurable
  include FileUtils

  def initialize(*)
    super

    self.singleton_class.__send__(:include, FileUtils::Verbose) if verbose?

    public_methods.each do |m|
      # rubocop:disable Style/AccessModifierDeclarations
      self.singleton_class.class_eval { public m }
      # rubocop:enable Style/AccessModifierDeclarations
    end
  end

  # @return [Boolean]
  def verbose?
    config.key?(:verbose) ? !!config[:verbose] : true
  end

  # @return [Array<Symbol>]
  def public_methods
    (super + [
      %i[cd chdir chmod chmod_R chown chown_R cmp],
      %i[compare_file compare_stream copy copy_entry copy_file],
      %i[copy_stream cp cp_r getwd identical? install link],
      %i[ln ln_s ln_sf makedirs mkdir mkdir_p mkpath move mv pwd],
      %i[remove remove_dir remove_entry remove_entry_secure remove_file],
      %i[rm rm_f rm_r rm_rf rmdir rmtree safe_unlink symlink touch uptodate?],
    ].flatten).sort
  end
end
