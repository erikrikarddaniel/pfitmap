class CreateHmmResultRowsHmmDbHits < ActiveRecord::Migration
  def change
    create_table :hmm_result_rows_hmm_db_hits do |t|
      t.references :hmmResultRow
      t.references :hmmDbHit

      t.timestamps
    end
    add_index :hmm_result_rows_hmm_db_hits, :hmmResultRow_id
    add_index :hmm_result_rows_hmm_db_hits, :hmmDbHit_id
  end
end
