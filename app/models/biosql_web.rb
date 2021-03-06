class BiosqlWeb < ActiveRecord::Base  
  HTTP_TIMEOUT = 6000

  self.abstract_class = true
  BASE_URL =  'http://biosql.scilifelab.se'

  def self.gi2ncbi_taxon_id(gi)
    options = {:headers => { 'Content-Type' => 'application/json', 'Accepts' => 'application/json'}, :body => {:gi => gi}.to_json, timeout: HTTP_TIMEOUT }
    response = HTTParty.get(BASE_URL + '/gi2ncbi_taxon_id.json', options)
    taxon_id = response.parsed_response["taxon_id"]
  end

  def self.gis2ncbi_taxon_ids(gis)
    options = {:headers => { 'Content-Type' => 'application/json', 'Accepts' => 'application/json'}, :body => {:gis => gis}.to_json, timeout: HTTP_TIMEOUT }
    response = HTTParty.get(BASE_URL + '/gis2ncbi_taxon_ids.json', options)
    ncbi_taxons_ids = response.parsed_response
  end

  def self.get_sequences_by_accessions(accessions,type)
    options = {:headers => { 'Content-Type' => 'application/json', 'Accepts' => 'application/json'}, :body => {:accessions => accessions}.to_json, timeout: HTTP_TIMEOUT }
    response = HTTParty.get(BASE_URL + "/get_gis_sequences.#{type}", options)
    sequences = response.parsed_response
    sequences
  end

  def self.gis2gi_queue(gis)
    options = {:headers => { 'Content-Type' => 'application/json', 'Accepts' => 'application/json'}, :body => {:gis => gis}.to_json, timeout: HTTP_TIMEOUT }
    response = HTTParty.get(BASE_URL + '/add_gis_to_queue', options)
    response = response.parsed_response
  end

  def self.organism_group2ncbi_taxon_ids(name)
    options = {:headers => { 'Content-Type' => 'application/json', 'Accepts' => 'application/json'}, timeout: HTTP_TIMEOUT }
    response = HTTParty.get(BASE_URL + "/organism_group_by_name/#{name}.json")
    wgs_ids = response.parsed_response["organism_group_rows"].map{ |ogr_hash| ogr_hash["ncbi_taxon_id"] }
  end

  def self.ncbi_taxon_id2full_taxon_hierarchy(ncbi_taxon_id)
    options = {:headers => { 'Content-Type' => 'application/json', 'Accepts' => 'application/json'}, :body => {:ncbi_taxon_id => ncbi_taxon_id}.to_json, timeout: HTTP_TIMEOUT }
    response = HTTParty.get(BASE_URL + '/ncbi_taxon_id2full_taxon_hierarchy.json', options)
    taxons = response.parsed_response
  end
  def self.ncbi_taxon_ids2full_taxon_hierarchies(ncbi_taxon_ids)
    options = {:headers => { 'Content-Type' => 'application/json', 'Accepts' => 'application/json'}, :body => {:ncbi_taxon_ids => ncbi_taxon_ids}.to_json, timeout: HTTP_TIMEOUT }
    response = HTTParty.get(BASE_URL + '/ncbi_taxon_ids2full_taxon_hierarchies.json', options)
    taxons = response.parsed_response
  end
end
