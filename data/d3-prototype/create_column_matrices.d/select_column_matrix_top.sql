SELECT
  taxa.*,
  COALESCE(SUM(nrda.n_proteins), 0) AS "protein:RNR I:NrdA:n_proteins",
  COALESCE(SUM(nrda.n_genomes_w_protein), 0) AS "protein:RNR I:NrdA:n_genomes_w_protein",
  COALESCE(SUM(nrdb.n_proteins), 0) AS "protein:RNR I:NrdB:n_proteins",
  COALESCE(SUM(nrdb.n_genomes_w_protein), 0) AS "protein:RNR I:NrdB:n_genomes_w_protein",
  COALESCE(SUM(nrdd.n_proteins), 0) AS "protein:RNR III:NrdD:n_proteins",
  COALESCE(SUM(nrdd.n_genomes_w_protein), 0) AS "protein:RNR III:NrdD:n_genomes_w_protein",
  COALESCE(SUM(nrdg.n_proteins), 0) AS "protein:RNR I:NrdG:n_proteins",
  COALESCE(SUM(nrdg.n_genomes_w_protein), 0) AS "protein:RNR I:NrdG:n_genomes_w_protein",
  COALESCE(SUM(nrdj.n_proteins), 0) AS "protein:RNR I:NrdJ:n_proteins",
  COALESCE(SUM(nrdj.n_genomes_w_protein), 0) AS "protein:RNR I:NrdJ:n_genomes_w_protein"
FROM
  (
    SELECT domain, phylum, class, "order", family, genus, species, strain, COUNT(*) AS n_genomes
    FROM ( SELECT DISTINCT domain, phylum, class, "order", family, genus, species, strain FROM row_matrix ) t
    GROUP BY 1,2,3,4,5,6,7,8
  ) taxa LEFT JOIN
  row_matrix nrda ON
    taxa.species = nrda.species AND 
    taxa.strain = nrda.strain AND
    nrda.protein0 = 'NrdA' LEFT JOIN
  row_matrix nrdb ON
    taxa.species = nrdb.species AND 
    taxa.strain = nrdb.strain AND
    nrdb.protein0 = 'NrdB' LEFT JOIN
  row_matrix nrdd ON
    taxa.species = nrdd.species AND 
    taxa.strain = nrdd.strain AND
    nrdd.protein0 = 'NrdD' LEFT JOIN
  row_matrix nrdg ON
    taxa.species = nrdg.species AND 
    taxa.strain = nrdg.strain AND
    nrdg.protein0 = 'NrdG' LEFT JOIN
  row_matrix nrdj ON
    taxa.species = nrdj.species AND 
    taxa.strain = nrdj.strain AND
    nrdj.protein0 = 'NrdJ'
GROUP BY
  1,2,3,4,5,6,7,8,9
;
