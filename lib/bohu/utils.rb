# frozen_string_literal: true

require_relative '../bohu'
require 'fileutils'

# Provide several file utility methods for copying, moving, removing, etc.
class Bohu::Utils
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

  # @see Bohu::Shell.sh
  def sh(*cmd)
    shell.sh(*cmd)
  end

  # @return [Boolean]
  def verbose?
    config.key?(:verbose) ? !!config[:verbose] : true
  end

  # @return [Array<Symbol>]
  def public_methods
    (super + [
      %i[cd chdir chmod chmod_R chown chown_R cmp compare_file],
      %i[compare_stream copy copy_entry copy_file copy_stream cp],
      %i[cp_r getwd identical? install link ln ln_s ln_sf makedirs],
      %i[mkdir mkdir_p mkpath move mv pwd remove remove_dir remove_entry],
      %i[remove_entry_secure remove_file rm rm_f rm_r rm_rf rmdir rmtree],
      %i[ruby safe_ln safe_unlink sh split_all symlink touch uptodate?],
    ].flatten).sort
  end

  protected

  # Get shell.
  #
  # Sheel verbosity is consistent with utils (``FileUtils``) verbosity.
  #
  # @return [Bohu::Shell]
  def shell
    @shell ||= Bohu::Shell
               .new(shell: {})
               .tap { |shell| shell.verbose = verbose? }
  end
end
