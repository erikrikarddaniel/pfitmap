class CreateDbSequenceBestProfiles < ActiveRecord::Migration
  def up
    execute '
CREATE OR REPLACE VIEW db_sequence_best_profiles AS
SELECT
  hmmrr.db_sequence_id AS db_sequence_id,
  hmmr.hmm_profile_id AS hmm_profile_id,
  hmmr.sequence_source_id AS sequence_source_id,
  hmmrr.id AS hmm_result_row_id,
  hmmrr.fullseq_score AS fullseq_score
FROM
  hmm_results hmmr JOIN
  hmm_result_rows hmmrr ON hmmr.id = hmmrr.hmm_result_id
WHERE hmmrr.fullseq_score = ( 
  SELECT MAX(fullseq_score)
  FROM
    hmm_result_rows hmmrrinner JOIN
    hmm_results hmmrinner ON hmmrrinner.hmm_result_id = hmmrinner.id
  WHERE
    hmmrrinner.db_sequence_id = hmmrr.db_sequence_id AND 
    hmmrinner.sequence_source_id = hmmr.sequence_source_id
  )
'
  end

  def down
    execute '
DROP VIEW db_sequence_best_profiles
'
  end
end
