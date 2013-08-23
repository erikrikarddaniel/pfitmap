SELECT
  taxa.*,
  COALESCE(NrdDa.n_proteins,0) AS "protein:RNR IIIa:NrdDa:n_proteins",
  COALESCE(NrdDa.n_genomes_w_protein,0) AS "protein:RNR IIIa:NrdDa:n_genomes_w_protein",
  COALESCE(NrdDb.n_proteins,0) AS "protein:RNR IIIb:NrdDb:n_proteins",
  COALESCE(NrdDb.n_genomes_w_protein,0) AS "protein:RNR IIIb:NrdDb:n_genomes_w_protein",
  COALESCE(NrdDc.n_proteins,0) AS "protein:RNR IIIc:NrdDc:n_proteins",
  COALESCE(NrdDc.n_genomes_w_protein,0) AS "protein:RNR IIIc:NrdDc:n_genomes_w_protein",
  COALESCE(NrdDd.n_proteins,0) AS "protein:RNRIIId:NrdDd:n_proteins",
  COALESCE(NrdDd.n_genomes_w_protein,0) AS "protein:RNRIIId:NrdDd:n_genomes_w_protein",
  COALESCE(NrdDf.n_proteins,0) AS "protein:RNR IIIf:NrdDf:n_proteins",
  COALESCE(NrdDf.n_genomes_w_protein,0) AS "proteif:RNR IIIf:NrdDf:n_genomes_w_protein",
  COALESCE(NrdDh.n_proteins,0) AS "protein:RNR IIIh:NrdDh:n_proteins",
  COALESCE(NrdDh.n_genomes_w_protein,0) AS "protein:RNR IIIh:NrdDh:n_genomes_w_protein",
  COALESCE(NrdDi.n_proteins,0) AS "protein:RNRIIIi:NrdDi:n_proteins",
  COALESCE(NrdDi.n_genomes_w_protein,0) AS "protein:RNRIIIi:NrdDi:n_genomes_w_protein"
FROM
  (
    SELECT domain, kingdom, phylum, class, "order", family, genus, species, strain, COUNT(*) AS n_genomes
    FROM ( SELECT DISTINCT domain, kingdom, phylum, class, "order", family, genus, species, strain FROM row_matrix ) t
    GROUP BY 1,2,3,4,5,6,7,8,9
  ) taxa 
  LEFT JOIN
  (
    SELECT 
      domain, kingdom, phylum, class, "order", family, genus, species, strain, SUM(n_proteins) AS n_proteins, CASE WHEN SUM(n_proteins) > 0 THEN 1 ELSE 0 END AS n_genomes_w_protein
    FROM
      row_matrix
    WHERE
      protein1 = 'NrdDa'
    GROUP BY
      1,2,3,4,5,6,7,8,9
  ) NrdDa ON
    taxa.species = NrdDa.species AND taxa.strain = NrdDa.strain
  LEFT JOIN
  (
    SELECT 
      domain, kingdom, phylum, class, "order", family, genus, species, strain, SUM(n_proteins) AS n_proteins, CASE WHEN SUM(n_proteins) > 0 THEN 1 ELSE 0 END AS n_genomes_w_protein
    FROM
      row_matrix
    WHERE
      protein1 = 'NrdDb'
    GROUP BY
      1,2,3,4,5,6,7,8,9
  ) NrdDb ON
    taxa.species = NrdDb.species AND taxa.strain = NrdDb.strain
  LEFT JOIN
  (
    SELECT 
      domain, kingdom, phylum, class, "order", family, genus, species, strain, SUM(n_proteins) AS n_proteins, CASE WHEN SUM(n_proteins) > 0 THEN 1 ELSE 0 END AS n_genomes_w_protein
    FROM
      row_matrix
    WHERE
      protein1 = 'NrdDc'
    GROUP BY
      1,2,3,4,5,6,7,8,9
  ) NrdDc ON
    taxa.species = NrdDc.species AND taxa.strain = NrdDc.strain
  LEFT JOIN
  (
    SELECT 
      domain, kingdom, phylum, class, "order", family, genus, species, strain, SUM(n_proteins) AS n_proteins, CASE WHEN SUM(n_proteins) > 0 THEN 1 ELSE 0 END AS n_genomes_w_protein
    FROM
      row_matrix
    WHERE
      protein1 = 'NrdDd'
    GROUP BY
      1,2,3,4,5,6,7,8,9
  ) NrdDd ON
    taxa.species = NrdDd.species AND taxa.strain = NrdDd.strain
  LEFT JOIN
  (
    SELECT 
      domain, kingdom, phylum, class, "order", family, genus, species, strain, SUM(n_proteins) AS n_proteins, CASE WHEN SUM(n_proteins) > 0 THEN 1 ELSE 0 END AS n_genomes_w_protein
    FROM
      row_matrix
    WHERE
      protein1 = 'NrdDf'
    GROUP BY
      1,2,3,4,5,6,7,8,9
  ) NrdDf ON
    taxa.species = NrdDf.species AND taxa.strain = NrdDf.strain
  LEFT JOIN
  (
    SELECT 
      domain, kingdom, phylum, class, "order", family, genus, species, strain, SUM(n_proteins) AS n_proteins, CASE WHEN SUM(n_proteins) > 0 THEN 1 ELSE 0 END AS n_genomes_w_protein
    FROM
      row_matrix
    WHERE
      protein1 = 'NrdDh'
    GROUP BY
      1,2,3,4,5,6,7,8,9
  ) NrdDh ON
    taxa.species = NrdDh.species AND taxa.strain = NrdDh.strain
  LEFT JOIN
  (
    SELECT 
      domain, kingdom, phylum, class, "order", family, genus, species, strain, SUM(n_proteins) AS n_proteins, CASE WHEN SUM(n_proteins) > 0 THEN 1 ELSE 0 END AS n_genomes_w_protein
    FROM
      row_matrix
    WHERE
      protein1 = 'NrdDi'
    GROUP BY
      1,2,3,4,5,6,7,8,9
  ) NrdDi ON
    taxa.species = NrdDi.species AND taxa.strain = NrdDi.strain
;
