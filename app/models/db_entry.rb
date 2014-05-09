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

class DbEntry < ActiveRecord::Base
  attr_accessible :gi, :db, :acc, :desc, :db_sequence_id
  has_many :hmm_result_rows, :through => :db_sequence
  belongs_to :db_sequence
  has_many :hmm_alignments, :through => :hmm_result_rows
  validates :gi, presence: true
  validates :db_sequence_id, presence: true

  def self.all_taxons
    gi_list = []
    self.select(:gi).each do |hit|
      gi_list << hit.gi
    end
    gi_taxons = BiosqlWeb.get_taxons_by_gis(gi_list)
    
  end

  def self.gis2gi_queue
    logger.info "Fetching all gis that are missing sequences"
    gis = DbEntry.find(:all,select: "gi", 
                         include: [:db_sequence], 
                         conditions: ["db_sequences.sequence IS NULL"])
              .map {|e| e.gi.to_s}

    logger.info "will send #{gis.length} nr of gis to Biosql queue"
    BiosqlWeb.gis2gi_queue(gis)
    logger.info "done sending gis to biosql queue"
  end


end
