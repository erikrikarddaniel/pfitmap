class CreateLoadDatabases < ActiveRecord::Migration
  def change
    create_table :load_databases do |t|
      t.string :taxonset
      t.string :name
      t.string :description
      t.boolean :active
      t.references :sequence_database

      t.timestamps
    end
    add_index :load_databases, :name, :unique => true
    add_index :load_databases, :sequence_database_id
  end
end
