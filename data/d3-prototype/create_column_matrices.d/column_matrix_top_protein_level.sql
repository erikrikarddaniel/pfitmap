SELECT
  taxa.*,
  COALESCE(NrdA.n_proteins,0) AS "protein:RNR I:NrdA:n_proteins",
  COALESCE(NrdA.n_genomes_w_protein,0) AS "protein:RNR I:NrdA:n_genomes_w_protein",
  COALESCE(NrdB.n_proteins,0) AS "protein:RNR I:NrdB:n_proteins",
  COALESCE(NrdB.n_genomes_w_protein,0) AS "protein:RNR I:NrdB:n_genomes_w_protein",
  COALESCE(NrdD.n_proteins,0) AS "protein:RNR III:NrdD:n_proteins",
  COALESCE(NrdD.n_genomes_w_protein,0) AS "protein:RNR III:NrdD:n_genomes_w_protein",
  COALESCE(NrdG.n_proteins,0) AS "protein:RNR III:NrdG:n_proteins",
  COALESCE(NrdG.n_genomes_w_protein,0) AS "protein:RNR III:NrdG:n_genomes_w_protein",
  COALESCE(NrdJ.n_proteins,0) AS "protein:RNR II:NrdJ:n_proteins",
  COALESCE(NrdJ.n_genomes_w_protein,0) AS "protein:RNR II:NrdJ:n_genomes_w_protein"
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
      protein0 = 'NrdA'
    GROUP BY
      1,2,3,4,5,6,7,8,9
  ) NrdA ON
    taxa.species = NrdA.species AND taxa.strain = NrdA.strain
  LEFT JOIN
  (
    SELECT 
      domain, kingdom, phylum, class, "order", family, genus, species, strain, SUM(n_proteins) AS n_proteins, CASE WHEN SUM(n_proteins) > 0 THEN 1 ELSE 0 END AS n_genomes_w_protein
    FROM
      row_matrix
    WHERE
      protein0 = 'NrdB'
    GROUP BY
      1,2,3,4,5,6,7,8,9
  ) NrdB ON
    taxa.species = NrdB.species AND taxa.strain = NrdB.strain
  LEFT JOIN
  (
    SELECT 
      domain, kingdom, phylum, class, "order", family, genus, species, strain, SUM(n_proteins) AS n_proteins, CASE WHEN SUM(n_proteins) > 0 THEN 1 ELSE 0 END AS n_genomes_w_protein
    FROM
      row_matrix
    WHERE
      protein0 = 'NrdD'
    GROUP BY
      1,2,3,4,5,6,7,8,9
  ) NrdD ON
    taxa.species = NrdD.species AND taxa.strain = NrdD.strain
  LEFT JOIN
  (
    SELECT 
      domain, kingdom, phylum, class, "order", family, genus, species, strain, SUM(n_proteins) AS n_proteins, CASE WHEN SUM(n_proteins) > 0 THEN 1 ELSE 0 END AS n_genomes_w_protein
    FROM
      row_matrix
    WHERE
      protein0 = 'NrdG'
    GROUP BY
      1,2,3,4,5,6,7,8,9
  ) NrdG ON
    taxa.species = NrdG.species AND taxa.strain = NrdG.strain
  LEFT JOIN
  (
    SELECT 
      domain, kingdom, phylum, class, "order", family, genus, species, strain, SUM(n_proteins) AS n_proteins, CASE WHEN SUM(n_proteins) > 0 THEN 1 ELSE 0 END AS n_genomes_w_protein
    FROM
      row_matrix
    WHERE
      protein0 = 'NrdJ'
    GROUP BY
      1,2,3,4,5,6,7,8,9
  ) NrdJ ON
    taxa.species = NrdJ.species AND taxa.strain = NrdJ.strain
;
