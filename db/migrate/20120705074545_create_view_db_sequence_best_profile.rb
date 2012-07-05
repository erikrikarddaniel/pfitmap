class CreateViewDbSequenceBestProfile < ActiveRecord::Migration
  def up
    execute 'create or replace view view_db_sequence_best_profiles as
select hmmp.id AS hmm_profile_id, ss.id AS sequence_source_id, dbs.id AS db_sequence_id, hmmrr.fullseq_score AS "fullseq_score"
from 
  db_sequences dbs join 
  hmm_result_rows hmmrr on dbs.id = hmmrr.db_sequence_id join
  hmm_results hmmr on hmmrr.hmm_result_id = hmmr.id join
  hmm_profiles hmmp on hmmr.hmm_profile_id = hmmp.id join
  sequence_sources ss on hmmr.sequence_source_id = ss.id
where hmmrr.fullseq_score = ( 
  select max(fullseq_score)
  from 
	hmm_result_rows hmmrrinner join 
	hmm_results hmmrinner on hmmrrinner.hmm_result_id = hmmrinner.id join
	sequence_sources ssinner on hmmrinner.sequence_source_id = ssinner.id
  where hmmrrinner.db_sequence_id = dbs.id AND
	ssinner.id = ss.id
)'
  end

  def down
    execute "DROP VIEW view_db_sequence_best_profiles"
  end
end
