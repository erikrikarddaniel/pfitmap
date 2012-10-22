class BiosqlWeb < ActiveRecord::Base  
  self.abstract_class = true
  BASE_URL = 'http://biosql.scilifelab.se'

  def self.get_taxon_by_gi(gi)
    options = {:headers => { 'Content-Type' => 'application/json', 'Accepts' => 'application/json'}, :body => {:gi => gi}.to_json}
    response = HTTParty.get(BASE_URL + '/taxon_for_gi.json', options)
    taxons = response.parsed_response
  end

  def self.all_wgs_with_full_taxa_test
    response = HTTParty.get(BASE_URL + '/gold_taxon_hierarchy_test.json')
    wgs_taxons = response.parsed_response
  end

  def self.wgs_ids
    response = HTTParty.get(BASE_URL + '/wgs_ids.json')
    wgs_ids = response.parsed_response
  end

  def self.full_taxa_for_wgs_id(wgs_id)
    options = {:headers => { 'Content-Type' => 'application/json', 'Accepts' => 'application/json'}, :body => {:id => wgs_id}.to_json}
    response = HTTParty.get(BASE_URL + '/full_taxa_for_wgs_id.json', options)
    taxons = response.parsed_response
  end
end
