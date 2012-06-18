class DescriptionShouldBeText < ActiveRecord::Migration
  def up
    remove_column :hmm_db_hits, :desc
    add_column :hmm_db_hits, :desc, :text
  end

  def down
    remove_column :hmm_db_hits, :desc
    add_column :hmm_db_hits, :desc, :string
  end
end
