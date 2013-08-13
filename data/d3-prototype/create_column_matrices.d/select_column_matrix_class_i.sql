SELECT
  taxa.*,
  COALESCE(SUM(nrdab.n_proteins), 0) AS "protein:RNR Ib:NrdE:n_proteins",
  COALESCE(SUM(nrdab.n_genomes_w_protein), 0) AS "protein:RNR Ib:NrdE:n_genomes_w_protein",
  COALESCE(SUM(nrdbb.n_proteins), 0) AS "protein:RNR Ib:NrdF:n_proteins",
  COALESCE(SUM(nrdbb.n_genomes_w_protein), 0) AS "protein:RNR Ib:NrdF:n_genomes_w_protein",
  COALESCE(SUM(nrdac.n_proteins), 0) AS "protein:RNR Ic:NrdAc:n_proteins",
  COALESCE(SUM(nrdac.n_genomes_w_protein), 0) AS "protein:RNR Ic:NrdAc:n_genomes_w_protein",
  COALESCE(SUM(nrdbc.n_proteins), 0) AS "protein:RNR Ic:NrdBc:n_proteins",
  COALESCE(SUM(nrdbc.n_genomes_w_protein), 0) AS "protein:RNR Ic:NrdBc:n_genomes_w_protein",
  COALESCE(SUM(nrdae.n_proteins), 0) AS "protein:RNR Ie:NrdAe:n_proteins",
  COALESCE(SUM(nrdae.n_genomes_w_protein), 0) AS "protein:RNR Ie:NrdAe:n_genomes_w_protein",
  COALESCE(SUM(nrdbe.n_proteins), 0) AS "protein:RNR Ie:NrdBe:n_proteins",
  COALESCE(SUM(nrdbe.n_genomes_w_protein), 0) AS "protein:RNR Ie:NrdBe:n_genomes_w_protein",
  COALESCE(SUM(nrdag.n_proteins), 0) AS "protein:RNR Ig:NrdAg:n_proteins",
  COALESCE(SUM(nrdag.n_genomes_w_protein), 0) AS "protein:RNR Ig:NrdAg:n_genomes_w_protein",
  COALESCE(SUM(nrdbg.n_proteins), 0) AS "protein:RNR Ig:NrdBg:n_proteins",
  COALESCE(SUM(nrdbg.n_genomes_w_protein), 0) AS "protein:RNR Ig:NrdBg:n_genomes_w_protein",
  COALESCE(SUM(nrdah.n_proteins), 0) AS "protein:RNR Ih:NrdAh:n_proteins",
  COALESCE(SUM(nrdah.n_genomes_w_protein), 0) AS "protein:RNR Ih:NrdAh:n_genomes_w_protein",
  COALESCE(SUM(nrdbh.n_proteins), 0) AS "protein:RNR Ih:NrdBh:n_proteins",
  COALESCE(SUM(nrdbh.n_genomes_w_protein), 0) AS "protein:RNR Ih:NrdBh:n_genomes_w_protein",
  COALESCE(SUM(nrdai.n_proteins), 0) AS "protein:RNR Ii:NrdAi:n_proteins",
  COALESCE(SUM(nrdai.n_genomes_w_protein), 0) AS "protein:RNR Ii:NrdAi:n_genomes_w_protein",
  COALESCE(SUM(nrdbi.n_proteins), 0) AS "protein:RNR Ii:NrdBi:n_proteins",
  COALESCE(SUM(nrdbi.n_genomes_w_protein), 0) AS "protein:RNR Ii:NrdBi:n_genomes_w_protein",
  COALESCE(SUM(nrdak.n_proteins), 0) AS "protein:RNR Ik:NrdAk:n_proteins",
  COALESCE(SUM(nrdak.n_genomes_w_protein), 0) AS "protein:RNR Ik:NrdAk:n_genomes_w_protein",
  COALESCE(SUM(nrdbk.n_proteins), 0) AS "protein:RNR Ik:NrdBk:n_proteins",
  COALESCE(SUM(nrdbk.n_genomes_w_protein), 0) AS "protein:RNR Ik:NrdBk:n_genomes_w_protein",
  COALESCE(SUM(nrdan.n_proteins), 0) AS "protein:RNR In:NrdAn:n_proteins",
  COALESCE(SUM(nrdan.n_genomes_w_protein), 0) AS "protein:RNR In:NrdAn:n_genomes_w_protein",
  COALESCE(SUM(nrdbn.n_proteins), 0) AS "protein:RNR In:NrdBn:n_proteins",
  COALESCE(SUM(nrdbn.n_genomes_w_protein), 0) AS "protein:RNR In:NrdBn:n_genomes_w_protein"
FROM
  (
    SELECT domain, phylum, class, "order", family, genus, species, strain, COUNT(*) AS n_genomes
    FROM ( SELECT DISTINCT domain, phylum, class, "order", family, genus, species, strain FROM row_matrix ) t
    GROUP BY 1,2,3,4,5,6,7,8
  ) taxa LEFT JOIN
  row_matrix nrdab ON
    taxa.species = nrdab.species AND 
    taxa.strain = nrdab.strain AND
    nrdab.protein1 = 'NrdE' LEFT JOIN
  row_matrix nrdbb ON
    taxa.species = nrdbb.species AND 
    taxa.strain = nrdbb.strain AND
    nrdbb.protein1 = 'NrdF' LEFT JOIN
  row_matrix nrdac ON
    taxa.species = nrdac.species AND 
    taxa.strain = nrdac.strain AND
    nrdac.protein1 = 'NrdAc' LEFT JOIN
  row_matrix nrdbc ON
    taxa.species = nrdbc.species AND 
    taxa.strain = nrdbc.strain AND
    nrdbc.protein1 = 'NrdBc' LEFT JOIN
  row_matrix nrdae ON
    taxa.species = nrdae.species AND 
    taxa.strain = nrdae.strain AND
    nrdae.protein1 = 'NrdAe' LEFT JOIN
  row_matrix nrdbe ON
    taxa.species = nrdbe.species AND 
    taxa.strain = nrdbe.strain AND
    nrdbe.protein1 = 'NrdBe' LEFT JOIN
  row_matrix nrdag ON
    taxa.species = nrdag.species AND 
    taxa.strain = nrdag.strain AND
    nrdag.protein1 = 'NrdAg' LEFT JOIN
  row_matrix nrdbg ON
    taxa.species = nrdbg.species AND 
    taxa.strain = nrdbg.strain AND
    nrdbg.protein1 = 'NrdBg' LEFT JOIN
  row_matrix nrdah ON
    taxa.species = nrdah.species AND 
    taxa.strain = nrdah.strain AND
    nrdah.protein1 = 'NrdAh' LEFT JOIN
  row_matrix nrdbh ON
    taxa.species = nrdbh.species AND 
    taxa.strain = nrdbh.strain AND
    nrdbh.protein1 = 'NrdBh' LEFT JOIN
  row_matrix nrdai ON
    taxa.species = nrdai.species AND 
    taxa.strain = nrdai.strain AND
    nrdai.protein1 = 'NrdAi' LEFT JOIN
  row_matrix nrdbi ON
    taxa.species = nrdbi.species AND 
    taxa.strain = nrdbi.strain AND
    nrdbi.protein1 = 'NrdBi' LEFT JOIN
  row_matrix nrdak ON
    taxa.species = nrdak.species AND 
    taxa.strain = nrdak.strain AND
    nrdak.protein1 = 'NrdAk' LEFT JOIN
  row_matrix nrdbk ON
    taxa.species = nrdbk.species AND 
    taxa.strain = nrdbk.strain AND
    nrdbk.protein1 = 'NrdBk' LEFT JOIN
  row_matrix nrdan ON
    taxa.species = nrdan.species AND 
    taxa.strain = nrdan.strain AND
    nrdan.protein1 = 'NrdAn' LEFT JOIN
  row_matrix nrdbn ON
    taxa.species = nrdbn.species AND 
    taxa.strain = nrdbn.strain AND
    nrdbn.protein1 = 'NrdBn'
GROUP BY
  1,2,3,4,5,6,7,8,9
;

