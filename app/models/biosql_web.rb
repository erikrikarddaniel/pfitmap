class BiosqlWeb < ActiveRecord::Base  
  self.abstract_class = true
  BASE_URL = 'http://biosql.scilifelab.se'

  def self.gi2ncbi_taxon_id(gi)
    options = {:headers => { 'Content-Type' => 'application/json', 'Accepts' => 'application/json'}, :body => {:gi => gi}.to_json}
    response = HTTParty.get(BASE_URL + '/gi2ncbi_taxon_id.json', options)
    taxon_id = response
  end

  def self.organism_group_taxon_ncbi_ids(name)
    response = HTTParty.get(BASE_URL + "/wgs_ncbi_taxon_ids/#{name}.json")
    wgs_ids = response.parsed_response[:organism_group_rows].map{ |ogr| ogr.organism_group_id }
  end

  def self.ncbi_taxon_id2full_taxon_hierarchy(ncbi_taxon_id)
    options = {:headers => { 'Content-Type' => 'application/json', 'Accepts' => 'application/json'}, :body => {:id => ncbi_taxon_id}.to_json}
    response = HTTParty.get(BASE_URL + '/ncbi_taxon_id2full_taxon_hierarchy.json', options)
    taxons = response.parsed_response
  end
end
