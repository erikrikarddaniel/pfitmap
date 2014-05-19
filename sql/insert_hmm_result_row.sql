CREATE OR REPLACE FUNCTION insert_hmm_result_row(
  hmm_result_id		integer,
  target_name		character varying(255),	target_acc		character varying(255),
  query_name		character varying(255),	query_acc		character varying(255),
  fullseq_evalue	double precision,	fullseq_score		double precision,	fullseq_bias		double precision,
  bestdom_evalue	double precision,	bestdom_score		double precision,	bestdom_bias		double precision,	
  domnumest_exp		double precision,	domnumest_reg		integer,		domnumest_clu		integer,	
  domnumest_ov		integer,		domnumest_env		integer,		domnumest_rep		integer,	
  domnumest_inc		integer,		domnumest_dom		integer,
  gis			integer[], dbs		varchar[], accnos	varchar[],		descs			varchar[]
) RETURNS integer AS $$
  DECLARE
    db_sequence_id	integer;

  BEGIN
    SELECT insert_db_sequence(gis, dbs, accnos, descs) INTO db_sequence_id;

    INSERT INTO hmm_result_rows( 
      hmm_result_id, db_sequence_id,
      target_name, target_acc,
      query_name, query_acc,
      fullseq_evalue, fullseq_score, fullseq_bias,
      bestdom_evalue, bestdom_score, bestdom_bias,
      domnumest_exp, domnumest_reg, domnumest_clu, domnumest_ov, domnumest_env, domnumest_rep, domnumest_inc, domnumest_dom,
      created_at, updated_at
    )
    SELECT
      hmm_result_id, db_sequence_id,
      target_name, target_acc,
      query_name, query_acc,
      fullseq_evalue, fullseq_score, fullseq_bias,
      bestdom_evalue, bestdom_score, bestdom_bias,
      domnumest_exp, domnumest_reg, domnumest_clu, domnumest_ov, domnumest_env, domnumest_rep, domnumest_inc, domnumest_dom,
      now(), now()
    ;

    RETURN MAX(id) FROM hmm_result_rows;
  END;
$$  LANGUAGE plpgsql;
