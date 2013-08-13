SELECT
  taxa.*,
  COALESCE(NrdE.n_proteins,0) AS "protein:RNR Ib:NrdE:n_proteins",
  COALESCE(NrdE.n_genomes_w_protein,0) AS "protein:RNR Ib:NrdE:n_genomes_w_protein",
  COALESCE(NrdF.n_proteins,0) AS "protein:RNR Ib:NrdF:n_proteins",
  COALESCE(NrdF.n_genomes_w_protein,0) AS "protein:RNR Ib:NrdF:n_genomes_w_protein",
  COALESCE(NrdAc.n_proteins,0) AS "protein:RNR Ic:NrdAc:n_proteins",
  COALESCE(NrdAc.n_genomes_w_protein,0) AS "protein:RNR Ic:NrdAc:n_genomes_w_protein",
  COALESCE(NrdBc.n_proteins,0) AS "protein:RNR Ic:NrdBc:n_proteins",
  COALESCE(NrdBc.n_genomes_w_protein,0) AS "protein:RNR Ic:NrdBc:n_genomes_w_protein",
  COALESCE(NrdAe.n_proteins,0) AS "protein:RNR Ie:NrdAe:n_proteins",
  COALESCE(NrdAe.n_genomes_w_protein,0) AS "protein:RNR Ie:NrdAe:n_genomes_w_protein",
  COALESCE(NrdBe.n_proteins,0) AS "protein:RNR Ie:NrdBe:n_proteins",
  COALESCE(NrdBe.n_genomes_w_protein,0) AS "protein:RNR Ie:NrdBe:n_genomes_w_protein",
  COALESCE(NrdAg.n_proteins,0) AS "protein:RNR Ig:NrdAg:n_proteins",
  COALESCE(NrdAg.n_genomes_w_protein,0) AS "protein:RNR Ig:NrdAg:n_genomes_w_protein",
  COALESCE(NrdBg.n_proteins,0) AS "protein:RNR Ig:NrdBg:n_proteins",
  COALESCE(NrdBg.n_genomes_w_protein,0) AS "protein:RNR Ig:NrdBg:n_genomes_w_protein",
  COALESCE(NrdAh.n_proteins,0) AS "protein:RNR Ih:NrdAh:n_proteins",
  COALESCE(NrdAh.n_genomes_w_protein,0) AS "protein:RNR Ih:NrdAh:n_genomes_w_protein",
  COALESCE(NrdBh.n_proteins,0) AS "protein:RNR Ih:NrdBh:n_proteins",
  COALESCE(NrdBh.n_genomes_w_protein,0) AS "protein:RNR Ih:NrdBh:n_genomes_w_protein",
  COALESCE(NrdAi.n_proteins,0) AS "protein:RNR Ii:NrdAi:n_proteins",
  COALESCE(NrdAi.n_genomes_w_protein,0) AS "protein:RNR Ii:NrdAi:n_genomes_w_protein",
  COALESCE(NrdBi.n_proteins,0) AS "protein:RNR Ii:NrdBi:n_proteins",
  COALESCE(NrdBi.n_genomes_w_protein,0) AS "protein:RNR Ii:NrdBi:n_genomes_w_protein",
  COALESCE(NrdAk.n_proteins,0) AS "protein:RNR Ik:NrdAk:n_proteins",
  COALESCE(NrdAk.n_genomes_w_protein,0) AS "protein:RNR Ik:NrdAk:n_genomes_w_protein",
  COALESCE(NrdBk.n_proteins,0) AS "protein:RNR Ik:NrdBk:n_proteins",
  COALESCE(NrdBk.n_genomes_w_protein,0) AS "protein:RNR Ik:NrdBk:n_genomes_w_protein",
  COALESCE(NrdAn.n_proteins,0) AS "protein:RNR In:NrdAn:n_proteins",
  COALESCE(NrdAn.n_genomes_w_protein,0) AS "protein:RNR In:NrdAn:n_genomes_w_protein",
  COALESCE(NrdBn.n_proteins,0) AS "protein:RNR In:NrdBn:n_proteins",
  COALESCE(NrdBn.n_genomes_w_protein,0) AS "protein:RNR In:NrdBn:n_genomes_w_protein"
FROM
  (
    SELECT domain, phylum, class, "order", family, genus, species, strain, COUNT(*) AS n_genomes
    FROM ( SELECT DISTINCT domain, phylum, class, "order", family, genus, species, strain FROM row_matrix ) t
    GROUP BY 1,2,3,4,5,6,7,8
  ) taxa 
  LEFT JOIN
  (
    SELECT 
      domain, phylum, class, "order", family, genus, species, strain, SUM(n_proteins) AS n_proteins, CASE WHEN SUM(n_proteins) > 0 THEN 1 ELSE 0 END AS n_genomes_w_protein
    FROM
      row_matrix
    WHERE
      protein1 = 'NrdE'
    GROUP BY
      1,2,3,4,5,6,7,8
  ) NrdE ON
    taxa.species = NrdE.species AND taxa.strain = NrdE.strain
  LEFT JOIN
  (
    SELECT 
      domain, phylum, class, "order", family, genus, species, strain, SUM(n_proteins) AS n_proteins, CASE WHEN SUM(n_proteins) > 0 THEN 1 ELSE 0 END AS n_genomes_w_protein
    FROM
      row_matrix
    WHERE
      protein1 = 'NrdF'
    GROUP BY
      1,2,3,4,5,6,7,8
  ) NrdF ON
    taxa.species = NrdF.species AND taxa.strain = NrdF.strain
  LEFT JOIN
  (
    SELECT 
      domain, phylum, class, "order", family, genus, species, strain, SUM(n_proteins) AS n_proteins, CASE WHEN SUM(n_proteins) > 0 THEN 1 ELSE 0 END AS n_genomes_w_protein
    FROM
      row_matrix
    WHERE
      protein1 = 'NrdAc'
    GROUP BY
      1,2,3,4,5,6,7,8
  ) NrdAc ON
    taxa.species = NrdAc.species AND taxa.strain = NrdAc.strain
  LEFT JOIN
  (
    SELECT 
      domain, phylum, class, "order", family, genus, species, strain, SUM(n_proteins) AS n_proteins, CASE WHEN SUM(n_proteins) > 0 THEN 1 ELSE 0 END AS n_genomes_w_protein
    FROM
      row_matrix
    WHERE
      protein1 = 'NrdBc'
    GROUP BY
      1,2,3,4,5,6,7,8
  ) NrdBc ON
    taxa.species = NrdBc.species AND taxa.strain = NrdBc.strain
  LEFT JOIN
  (
    SELECT 
      domain, phylum, class, "order", family, genus, species, strain, SUM(n_proteins) AS n_proteins, CASE WHEN SUM(n_proteins) > 0 THEN 1 ELSE 0 END AS n_genomes_w_protein
    FROM
      row_matrix
    WHERE
      protein1 = 'NrdAe'
    GROUP BY
      1,2,3,4,5,6,7,8
  ) NrdAe ON
    taxa.species = NrdAe.species AND taxa.strain = NrdAe.strain
  LEFT JOIN
  (
    SELECT 
      domain, phylum, class, "order", family, genus, species, strain, SUM(n_proteins) AS n_proteins, CASE WHEN SUM(n_proteins) > 0 THEN 1 ELSE 0 END AS n_genomes_w_protein
    FROM
      row_matrix
    WHERE
      protein1 = 'NrdBe'
    GROUP BY
      1,2,3,4,5,6,7,8
  ) NrdBe ON
    taxa.species = NrdBe.species AND taxa.strain = NrdBe.strain
  LEFT JOIN
  (
    SELECT 
      domain, phylum, class, "order", family, genus, species, strain, SUM(n_proteins) AS n_proteins, CASE WHEN SUM(n_proteins) > 0 THEN 1 ELSE 0 END AS n_genomes_w_protein
    FROM
      row_matrix
    WHERE
      protein1 = 'NrdAg'
    GROUP BY
      1,2,3,4,5,6,7,8
  ) NrdAg ON
    taxa.species = NrdAg.species AND taxa.strain = NrdAg.strain
  LEFT JOIN
  (
    SELECT 
      domain, phylum, class, "order", family, genus, species, strain, SUM(n_proteins) AS n_proteins, CASE WHEN SUM(n_proteins) > 0 THEN 1 ELSE 0 END AS n_genomes_w_protein
    FROM
      row_matrix
    WHERE
      protein1 = 'NrdBg'
    GROUP BY
      1,2,3,4,5,6,7,8
  ) NrdBg ON
    taxa.species = NrdBg.species AND taxa.strain = NrdBg.strain
  LEFT JOIN
  (
    SELECT 
      domain, phylum, class, "order", family, genus, species, strain, SUM(n_proteins) AS n_proteins, CASE WHEN SUM(n_proteins) > 0 THEN 1 ELSE 0 END AS n_genomes_w_protein
    FROM
      row_matrix
    WHERE
      protein1 = 'NrdAh'
    GROUP BY
      1,2,3,4,5,6,7,8
  ) NrdAh ON
    taxa.species = NrdAh.species AND taxa.strain = NrdAh.strain
  LEFT JOIN
  (
    SELECT 
      domain, phylum, class, "order", family, genus, species, strain, SUM(n_proteins) AS n_proteins, CASE WHEN SUM(n_proteins) > 0 THEN 1 ELSE 0 END AS n_genomes_w_protein
    FROM
      row_matrix
    WHERE
      protein1 = 'NrdBh'
    GROUP BY
      1,2,3,4,5,6,7,8
  ) NrdBh ON
    taxa.species = NrdBh.species AND taxa.strain = NrdBh.strain
  LEFT JOIN
  (
    SELECT 
      domain, phylum, class, "order", family, genus, species, strain, SUM(n_proteins) AS n_proteins, CASE WHEN SUM(n_proteins) > 0 THEN 1 ELSE 0 END AS n_genomes_w_protein
    FROM
      row_matrix
    WHERE
      protein1 = 'NrdAi'
    GROUP BY
      1,2,3,4,5,6,7,8
  ) NrdAi ON
    taxa.species = NrdAi.species AND taxa.strain = NrdAi.strain
  LEFT JOIN
  (
    SELECT 
      domain, phylum, class, "order", family, genus, species, strain, SUM(n_proteins) AS n_proteins, CASE WHEN SUM(n_proteins) > 0 THEN 1 ELSE 0 END AS n_genomes_w_protein
    FROM
      row_matrix
    WHERE
      protein1 = 'NrdBi'
    GROUP BY
      1,2,3,4,5,6,7,8
  ) NrdBi ON
    taxa.species = NrdBi.species AND taxa.strain = NrdBi.strain
  LEFT JOIN
  (
    SELECT 
      domain, phylum, class, "order", family, genus, species, strain, SUM(n_proteins) AS n_proteins, CASE WHEN SUM(n_proteins) > 0 THEN 1 ELSE 0 END AS n_genomes_w_protein
    FROM
      row_matrix
    WHERE
      protein1 = 'NrdAk'
    GROUP BY
      1,2,3,4,5,6,7,8
  ) NrdAk ON
    taxa.species = NrdAk.species AND taxa.strain = NrdAk.strain
  LEFT JOIN
  (
    SELECT 
      domain, phylum, class, "order", family, genus, species, strain, SUM(n_proteins) AS n_proteins, CASE WHEN SUM(n_proteins) > 0 THEN 1 ELSE 0 END AS n_genomes_w_protein
    FROM
      row_matrix
    WHERE
      protein1 = 'NrdBk'
    GROUP BY
      1,2,3,4,5,6,7,8
  ) NrdBk ON
    taxa.species = NrdBk.species AND taxa.strain = NrdBk.strain
  LEFT JOIN
  (
    SELECT 
      domain, phylum, class, "order", family, genus, species, strain, SUM(n_proteins) AS n_proteins, CASE WHEN SUM(n_proteins) > 0 THEN 1 ELSE 0 END AS n_genomes_w_protein
    FROM
      row_matrix
    WHERE
      protein1 = 'NrdAn'
    GROUP BY
      1,2,3,4,5,6,7,8
  ) NrdAn ON
    taxa.species = NrdAn.species AND taxa.strain = NrdAn.strain
  LEFT JOIN
  (
    SELECT 
      domain, phylum, class, "order", family, genus, species, strain, SUM(n_proteins) AS n_proteins, CASE WHEN SUM(n_proteins) > 0 THEN 1 ELSE 0 END AS n_genomes_w_protein
    FROM
      row_matrix
    WHERE
      protein1 = 'NrdBn'
    GROUP BY
      1,2,3,4,5,6,7,8
  ) NrdBn ON
    taxa.species = NrdBn.species AND taxa.strain = NrdBn.strain
;
