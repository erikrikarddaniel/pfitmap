class AddAbbreviationToEnzyme < ActiveRecord::Migration
  def change
    add_column :enzymes, :abbreviation, :string
  end
end
