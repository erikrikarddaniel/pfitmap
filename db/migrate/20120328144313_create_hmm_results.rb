class CreateHmmResults < ActiveRecord::Migration
  def change
    create_table :hmm_results do |t|
      t.datetime :executed
      t.references :sequence_db

      t.timestamps
    end
    add_index :hmm_results, :sequence_db_id
  end
end
