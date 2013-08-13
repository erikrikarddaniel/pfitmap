select
  '' as domain,
  '' as phylum,
  '' as class,
  '' as order,
  '' as family,
  '' as genus,
  '' as species,
  t0.name as strain,
  '' as protein0,
  p.name as protein1,
  '' as protein2,
  '' as protein3,
  '' as protein4,
  '' as enzyme0,
  e.abbreviation as enzyme1,
  '' as enzyme2,
  '' as enzyme3,
  '' as enzyme4,
  pc.no_genomes,
  pc.no_proteins,
  pc.no_genomes_with_proteins
from
  protein_counts pc join taxons t0 on pc.taxon_id = t0.id
  join proteins p on pc.protein_id = p.id
  join enzyme_profiles ep on p.hmm_profile_id = ep.hmm_profile_id
  join enzymes e on ep.enzyme_id = e.id
where
  pc.no_proteins > 0 and
  t0.rank in ('species', 'no rank') and
  t0.name not in ('root')
;
