class AddColumnsToTaxon < ActiveRecord::Migration
  def change 
    add_column    :taxons, :domain, :string
    add_column    :taxons, :kingdom, :string
    add_column    :taxons, :phylum, :string
    add_column    :taxons, :taxclass, :string
    add_column    :taxons, :taxorder, :string
    add_column    :taxons, :family, :string
    add_column    :taxons, :genus, :string
    add_column    :taxons, :species, :string
    add_column    :taxons, :strain, :string
  end
end
