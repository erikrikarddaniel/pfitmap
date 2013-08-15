-- Creates a table into which a data matrix with taxon hierarchy and protein hierarchy
-- can be inserted. 
--
-- Only used to generate matrices with organisms as rows and protein counts as columns.

CREATE TABLE row_matrix (
  domain		text,
  kingdom		text,
  phylum		text,
  class			text,
  "order"		text,
  family		text,
  genus			text,
  species		text,
  strain		text,
  protein0		text,
  protein1		text,
  protein2		text,
  protein3		text,
  protein4		text,
  n_proteins		integer,
  n_genomes_w_protein	integer
);
