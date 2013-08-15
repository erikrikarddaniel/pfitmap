all_tsvs: column_matrix_rnr_iii.tsv column_matrix_rnr_i.tsv column_matrix_top_protein_level.tsv

%.tsv: %.sql
	psql < $< | grep -v '^-' | grep -v " rows)" | sed "s/ *| */\t/g" | sed "s/^ *//" | grep -v "^$$" > $@
