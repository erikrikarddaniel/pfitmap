class BiosqlWeb < ActiveRecord::Base  
  self.abstract_class = true
  BASE_URL = 'http://biosql.scilifelab.se'
  def self.get_taxons_by_gis(gis)
    options = {:headers => { 'Content-Type' => 'application/json', 'Accepts' => 'application/json'}, :body => {:gis => gis}.to_json}
    response = HTTParty.get(BASE_URL + '/fetch_gis.json', options)
    taxons = response.parsed_response
  end

  def self.all_wgs_with_full_taxa
    response = HTTParty.get(BASE_URL + '/gold_taxon_hierarchy.json')
    wgs_taxons = response.parsed_response
  end
end
