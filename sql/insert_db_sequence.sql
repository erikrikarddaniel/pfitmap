CREATE OR REPLACE FUNCTION insert_db_sequence(gis integer[], dbs varchar(255)[], accs varchar(255)[], descs varchar(255)[]) RETURNS INTEGER AS $$
  DECLARE
    db_sequence_id integer;
    tmpi	   integer;
  BEGIN
    SELECT DISTINCT dbe.db_sequence_id INTO db_sequence_id
    FROM db_entries dbe WHERE gi = ANY (gis)
    ;
    IF NOT FOUND THEN
      INSERT INTO db_sequences(created_at, updated_at) SELECT now(), now();
      SELECT MAX(id) INTO db_sequence_id FROM db_sequences;
    END IF;

    FOR i IN 1..array_length(gis, 1) LOOP
      SELECT insert_db_entry(db_sequence_id, gis[i], dbs[i], accs[i], descs[i]) INTO tmpi;
    END LOOP;

    RETURN db_sequence_id;
  END;
$$  LANGUAGE plpgsql;
