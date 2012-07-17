class BiosqlWeb < ActiveRecord::Base  
  self.abstract_class = true
  BASE_URL = 'http://biosql.scilifelab.se'
  def self.get_taxons_by_gi(gi)
    response = HTTParty.get(BASE_URL + '/gi/' + gi + '.json')
    taxons = response.parsed_response
  end

  def self.all_wgs_gis_with_taxa
    response = HTTParty.get(BASE_URL + '/gold_taxon_hierarchy.json')
    wgs_taxons = response.parsed_response
  end
end
