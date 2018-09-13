# frozen_string_literal: true

Sham.config(FactoryStruct, :shell) do |c|
  c.attributes do
    {
      # interesting methods
      im: %i[sh capture capture!].sort
    }
  end
end
