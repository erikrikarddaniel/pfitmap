%.tsv: %.sql
	psql < $< | grep -v '^-' | grep -v " rows)" | sed "s/ *| */\t/g" | sed "s/^ *//" | grep -v "^$$" > $@
