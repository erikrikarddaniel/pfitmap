class RenameColumnsInProteinAndTaxon < ActiveRecord::Migration
  def change
    rename_column :proteins, :group, :protgroup
    rename_column :taxons, :family, :taxfamily
  end
end
