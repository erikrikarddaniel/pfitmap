CREATE OR REPLACE FUNCTION insert_db_entry(db_sequence_id integer, igi integer, idb varchar(255), iacc varchar(255), idesc varchar(255)) RETURNS INTEGER AS $$
  DECLARE
    db_entry_id integer;

  BEGIN
    SELECT id INTO db_entry_id
    FROM db_entries dbe WHERE dbe.gi = igi;

    IF NOT FOUND THEN
      INSERT INTO db_entries(db_sequence_id, gi, db, acc, "desc", created_at, updated_at)
      SELECT db_sequence_id, igi, idb, iacc, idesc, now(), now();
      SELECT currval('db_entries_id_seq') INTO db_entry_id;
    END IF;

    RETURN db_entry_id;
  END;
$$  LANGUAGE plpgsql;
