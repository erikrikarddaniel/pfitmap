select
  t0.name as organism_name,
  t0.rank as organism_rank,
  p.name as protein_name,
  p.rank as protein_rank,
  e.abbreviation as enzyme_name,
  pc.no_genomes,
  pc.no_proteins,
  pc.no_genomes_with_proteins
from
  protein_counts pc join taxons t0 on pc.taxon_id = t0.id
  join proteins p on pc.protein_id = p.id
  join enzyme_profiles ep on p.hmm_profile_id = ep.hmm_profile_id
  join enzymes e on ep.enzyme_id = e.id
where
  pc.taxon_id not in ( select distinct parent_id from taxons ) and
  pc.protein_id not in ( select distinct parent_id from proteins )
;
