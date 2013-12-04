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

  def gis2qi_queue
    gis = self.find(:all,select: "gi", 
                         include: [:db_sequence], 
                         conditions: ["db_sequences.sequence IS NULL"])
              .map {|e| e.gi.to_s}

    BiosqlWeb.gis2queue(gis)
  end


end
