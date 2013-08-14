class RenameEvalueToCevalueInHmmAlignment < ActiveRecord::Migration
  def change
    rename_column :hmm_alignments, :evalue, :cevalue
  end
end
