class CreatePfitmapSequences < ActiveRecord::Migration
  def change
    create_table :pfitmap_sequences do |t|
      t.references :db_sequence
      
      t.timestamps
    end
    add_index :pfitmap_sequences, :db_sequence_id
  end
end
