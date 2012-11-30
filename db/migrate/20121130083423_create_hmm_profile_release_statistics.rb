class CreateHmmProfileReleaseStatistics < ActiveRecord::Migration
  def up
    execute '
CREATE OR REPLACE VIEW hmm_profile_release_statistics AS
SELECT 
  dbbp.hmm_profile_id, 
  dbbp.sequence_source_id, 
  ps.pfitmap_release_id, 
  COUNT(*), 
  MIN(fullseq_score), 
  MAX(fullseq_score)
FROM
  db_sequence_best_profiles dbbp LEFT JOIN 
  pfitmap_sequences ps ON 
  dbbp.db_sequence_id = ps.db_sequence_id AND 
  dbbp.hmm_profile_id = ps.hmm_profile_id 
GROUP BY
  dbbp.hmm_profile_id, 
  dbbp.sequence_source_id, 
  ps.pfitmap_release_id
'
  end

  def down
    execute '
DROP VIEW hmm_profile_release_statistics
'
  end
end
