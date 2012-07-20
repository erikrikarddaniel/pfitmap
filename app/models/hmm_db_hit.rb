# == Schema Information
#
# Table name: hmm_db_hits
#
#  id             :integer         not null, primary key
#  gi             :integer
#  db             :string(255)
#  acc            :string(255)
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#  db_sequence_id :integer
#  desc           :text
#

class HmmDbHit < ActiveRecord::Base
  attr_accessible :gi, :db, :acc, :desc, :db_sequence_id
  has_many :hmm_result_rows, :through => :db_sequence
  belongs_to :db_sequence
  validates :gi, presence: true
  validates :db_sequence_id, presence: true

  def self.all_taxons
    gi_list = []
    self.select(:gi).each do |hit|
      gi_list << hit.gi
    end
    gi_taxons = BiosqlWeb.get_taxons_by_gis(gi_list)
    
  end

  def self.all_taxons_for(pr)
    gi_list = []
    pr.hmm_db_hits.select(:gi).each do |hit|
      gi_list << hit.gi
    end
    gi_taxons = BiosqlWeb.get_taxons_by_gis(gi_list)

    logger.debug "#{__FILE__}"
    logger.debug "blabla this the pr.hmm_db_hits.select(:gi) in the hmm_db_hit model  #{pr.hmm_db_hits.select(:gi).all}"

    logger.debug "#{__FILE__}"
    logger.debug "blabla this the gi list in the hmm_db_hit model  #{gi_list}"
    
    logger.debug "#{__FILE__}"
    logger.debug "blabla this the taxons in the hmm_db_hit model  #{gi_taxons}"

  end
 
end
