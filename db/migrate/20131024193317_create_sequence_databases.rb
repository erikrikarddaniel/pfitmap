class CreateSequenceDatabases < ActiveRecord::Migration
  def change
    create_table :sequence_databases do |t|
      t.string :db
      t.string :abbreviation
      t.string :home_page
      t.string :accession_url

      t.timestamps
    end
  end
end
