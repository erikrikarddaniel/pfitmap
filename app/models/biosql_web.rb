class BiosqlWeb < ActiveRecord::Base  
  BASE_URL = 'http://biosql.scilifelab.se'
  def get_taxons_by_gi(gi)
    response = HTTParty.get(BASE_URL + '/gi/' + gi + '.json')
    taxons = JSON.parse(response)
  end

  def all_wgs_gis_with_taxa
    response = HTTParty.gert(BASE_URL + '/gold.json')
    wgs_taxons = JSON.parse(response)
  end
end
