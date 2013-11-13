class ProteinSubClassCount < ActiveRecord::Migration
  def up
    execute '
CREATE OR REPLACE VIEW protein_sub_class_counts AS
SELECT 
  t.domain, t.kingdom, t.phylum, t.taxclass, t.taxorder, t.taxfamily, t.genus, t.species, t.strain, 
  protfamily, protclass, subclass,
  pc.released_db_id,
  SUM(pc.no_proteins) AS n_proteins,
  1 AS n_genomes_w_protein
FROM
  taxons t JOIN protein_counts pc ON t.id = pc.taxon_id JOIN
  proteins p on pc.protein_id = p.id
GROUP BY
  t.domain, t.kingdom, t.phylum, t.taxclass, t.taxorder, t.taxfamily, t.genus, t.species, t.strain, protfamily, protclass, subclass, pc.released_db_id
ORDER BY 
  t.domain, t.kingdom, t.phylum, t.taxclass, t.taxorder, t.taxfamily, t.genus, t.species, t.strain, protfamily, protclass, subclass
'
  end

  def down
    execute '
DROP VIEW protein_sub_class_counts
'
  end
end
