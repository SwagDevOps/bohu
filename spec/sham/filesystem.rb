# frozen_string_literal: true

Sham.config(FactoryStruct, :filesystem) do |c|
  c.attributes do
    {
      # interesting methods (from FileUtils)
      im: [
        %i[cd chdir chmod chmod_R chown chown_R cmp],
        %i[compare_file compare_stream copy copy_entry copy_file],
        %i[copy_stream cp cp_r getwd identical? install link],
        %i[ln ln_s ln_sf makedirs mkdir mkdir_p mkpath move mv pwd],
        %i[remove remove_dir remove_entry remove_entry_secure remove_file],
        %i[rm rm_f rm_r rm_rf rmdir rmtree safe_unlink symlink touch uptodate?],
      ].flatten.sort
    }
  end
end
