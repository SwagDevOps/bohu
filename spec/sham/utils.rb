# frozen_string_literal: true

Sham.config(FactoryStruct, :utils) do |c|
  c.attributes do
    {
      # interesting methods (from FileUtils)
      im: [
        %i[cd chdir chmod chmod_R chown chown_R cmp compare_file],
        %i[compare_stream copy copy_entry copy_file copy_stream cp],
        %i[cp_r getwd identical? install link ln ln_s ln_sf makedirs],
        %i[mkdir mkdir_p mkpath move mv pwd remove remove_dir remove_entry],
        %i[remove_entry_secure remove_file rm rm_f rm_r rm_rf rmdir rmtree],
        %i[ruby safe_ln safe_unlink sh split_all symlink touch uptodate?],
      ].flatten
    }
  end
end
