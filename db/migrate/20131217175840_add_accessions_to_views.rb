class AddAccessionsToViews < ActiveRecord::Migration
  def up
    execute '
DROP VIEW protein_family_counts;
CREATE OR REPLACE VIEW protein_family_counts AS
SELECT 
  t.domain, t.kingdom, t.phylum, t.taxclass, t.taxorder, t.taxfamily, t.genus, t.species, t.strain, 
  protfamily, 
  pc.released_db_id, STRING_AGG(pc.all_accessions,\',\') AS all_accessions, STRING_AGG(pc.counted_accessions,\',\') AS counted_accessions,
  SUM(pc.no_proteins) AS n_proteins,
  1 AS n_genomes_w_protein
FROM
  taxons t JOIN protein_counts pc ON t.id = pc.taxon_id JOIN
  proteins p on pc.protein_id = p.id
GROUP BY
  t.domain, t.kingdom, t.phylum, t.taxclass, t.taxorder, t.taxfamily, t.genus, t.species, t.strain, protfamily, pc.released_db_id
ORDER BY 
  t.domain, t.kingdom, t.phylum, t.taxclass, t.taxorder, t.taxfamily, t.genus, t.species, t.strain, protfamily;
'

    execute '
DROP VIEW protein_class_counts;
CREATE OR REPLACE VIEW protein_class_counts AS
SELECT 
  t.domain, t.kingdom, t.phylum, t.taxclass, t.taxorder, t.taxfamily, t.genus, t.species, t.strain, 
  protfamily, protclass,
  pc.released_db_id, STRING_AGG(pc.all_accessions,\',\') AS all_accessions, STRING_AGG(pc.counted_accessions,\',\') AS counted_accessions,
  SUM(pc.no_proteins) AS n_proteins,
  1 AS n_genomes_w_protein
FROM
  taxons t JOIN protein_counts pc ON t.id = pc.taxon_id JOIN
  proteins p on pc.protein_id = p.id
GROUP BY
  t.domain, t.kingdom, t.phylum, t.taxclass, t.taxorder, t.taxfamily, t.genus, t.species, t.strain, protfamily, protclass, pc.released_db_id
ORDER BY 
  t.domain, t.kingdom, t.phylum, t.taxclass, t.taxorder, t.taxfamily, t.genus, t.species, t.strain, protfamily, protclass;
'
    execute '
DROP VIEW protein_sub_class_counts;
CREATE OR REPLACE VIEW protein_sub_class_counts AS
SELECT 
  t.domain, t.kingdom, t.phylum, t.taxclass, t.taxorder, t.taxfamily, t.genus, t.species, t.strain, 
  protfamily, protclass, subclass,
  pc.released_db_id, STRING_AGG(pc.all_accessions,\',\') AS all_accessions, STRING_AGG(pc.counted_accessions,\',\') AS counted_accessions,
  SUM(pc.no_proteins) AS n_proteins,
  1 AS n_genomes_w_protein
FROM
  taxons t JOIN protein_counts pc ON t.id = pc.taxon_id JOIN
  proteins p on pc.protein_id = p.id
GROUP BY
  t.domain, t.kingdom, t.phylum, t.taxclass, t.taxorder, t.taxfamily, t.genus, t.species, t.strain, protfamily, protclass, subclass, pc.released_db_id
ORDER BY 
  t.domain, t.kingdom, t.phylum, t.taxclass, t.taxorder, t.taxfamily, t.genus, t.species, t.strain, protfamily, protclass, subclass;
'
    execute '
DROP VIEW protein_group_counts;
CREATE OR REPLACE VIEW protein_group_counts AS
SELECT 
  t.domain, t.kingdom, t.phylum, t.taxclass, t.taxorder, t.taxfamily, t.genus, t.species, t.strain, 
  p.protfamily, p.protclass, p.subclass, p.protgroup,
  pc.released_db_id, STRING_AGG(pc.all_accessions,\',\') AS all_accessions, STRING_AGG(pc.counted_accessions,\',\') AS counted_accessions,
  SUM(pc.no_proteins) AS n_proteins,
  1 AS n_genomes_w_protein
FROM
  taxons t JOIN protein_counts pc ON t.id = pc.taxon_id JOIN
  proteins p on pc.protein_id = p.id
GROUP BY
  t.domain, t.kingdom, t.phylum, t.taxclass, t.taxorder, t.taxfamily, t.genus, t.species, t.strain, p.protfamily, p.protclass, p.subclass, p.protgroup, pc.released_db_id
ORDER BY 
  t.domain, t.kingdom, t.phylum, t.taxclass, t.taxorder, t.taxfamily, t.genus, t.species, t.strain, p.protfamily, p.protclass, p.subclass, p.protgroup
'
    execute '
DROP VIEW protein_sub_group_counts;
CREATE OR REPLACE VIEW protein_sub_group_counts AS
SELECT 
  t.domain, t.kingdom, t.phylum, t.taxclass, t.taxorder, t.taxfamily, t.genus, t.species, t.strain, 
  p.protfamily, p.protclass,p.subclass, p.protgroup, p.subgroup,
  pc.released_db_id, STRING_AGG(pc.all_accessions,\',\') AS all_accessions, STRING_AGG(pc.counted_accessions,\',\') AS counted_accessions,
  SUM(pc.no_proteins) AS n_proteins,
  1 AS n_genomes_w_protein
FROM
  taxons t JOIN protein_counts pc ON t.id = pc.taxon_id JOIN
  proteins p on pc.protein_id = p.id
GROUP BY
  t.domain, t.kingdom, t.phylum, t.taxclass, t.taxorder, t.taxfamily, t.genus, t.species, t.strain, p.protfamily, p.protclass, p.subclass, p.protgroup, p.subgroup,  pc.released_db_id
ORDER BY 
  t.domain, t.kingdom, t.phylum, t.taxclass, t.taxorder, t.taxfamily, t.genus, t.species, t.strain, p.protfamily, p.protclass, p.subclass, p.protgroup, p.subgroup;
'
  end

  def down
    execute '
DROP VIEW protein_family_counts
'
    execute '
DROP VIEW protein_class_counts
'
    execute '
DROP VIEW protein_sub_class_counts
'
    execute '
DROP VIEW protein_group_counts
'
    execute '
DROP VIEW protein_sub_group_counts
'
  end
end
