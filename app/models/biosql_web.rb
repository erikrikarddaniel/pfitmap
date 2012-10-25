class BiosqlWeb < ActiveRecord::Base  
  self.abstract_class = true
  BASE_URL = 'http://biosql.scilifelab.se'

  def self.get_taxons_ncbi_id_by_gi(gi)
    options = {:headers => { 'Content-Type' => 'application/json', 'Accepts' => 'application/json'}, :body => {:gi => gi}.to_json}
    response = HTTParty.get(BASE_URL + '/gi2ncbi_taxon_id.json', options)
    taxons = response.parsed_response
  end

  def self.wgs_ncbi_ids
    response = HTTParty.get(BASE_URL + '/wgs_ncbi_taxon_ids.json')
    wgs_ids = response.parsed_response
  end

  def self.full_taxa_for_ncbi_id(wgs_id)
    options = {:headers => { 'Content-Type' => 'application/json', 'Accepts' => 'application/json'}, :body => {:id => wgs_id}.to_json}
    response = HTTParty.get(BASE_URL + '/ncbi_taxon_id2full_taxon.json', options)
    taxons = response.parsed_response
  end
end
