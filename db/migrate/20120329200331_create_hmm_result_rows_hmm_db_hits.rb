class CreateHmmResultRowsHmmDbHits < ActiveRecord::Migration
  def change
    create_table :hmm_result_rows_hmm_db_hits do |t|
      t.references :hmm_result_row
      t.references :hmm_db_hit

      t.timestamps
    end
    add_index :hmm_result_rows_hmm_db_hits, :hmm_result_row_id
    add_index :hmm_result_rows_hmm_db_hits, :hmm_db_hit_id
  end
end
