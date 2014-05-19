CREATE OR REPLACE FUNCTION insert_db_entry(igi integer, idb varchar(255), iacc varchar(255)) RETURNS INTEGER AS $$
  DECLARE
    db_entry_id integer;

  BEGIN
    SELECT id INTO db_entry_id
    FROM db_entries dbe WHERE dbe.gi = igi;

    IF NOT FOUND THEN
      INSERT INTO db_entries(gi, db, acc, created_at, updated_at)
      SELECT igi, idb, iacc, now(), now();
      SELECT currval('db_entries_id_seq') INTO db_entry_id;
    END IF;

    RETURN db_entry_id;
  END;
$$  LANGUAGE plpgsql;
