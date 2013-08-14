class CreateHmmAlignments < ActiveRecord::Migration
  def change
    create_table :hmm_alignments do |t|
      t.integer :hmm_result_row_id
      t.float :score
      t.float :bias
      t.float :evalue
      t.float :ievalue
      t.integer :hmmfrom
      t.integer :hmmto
      t.integer :alifrom
      t.integer :alito
      t.integer :envfrom
      t.integer :envto
      t.float :acc
      t.text :hmm_line
      t.text :match_line
      t.text :target_line
      t.text :pp_line

      t.timestamps
    end
  end
end
