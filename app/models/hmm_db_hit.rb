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

  def all_taxons
    taxons = http_get_taxons_by_gi(self.gi)
  end
 
  private
  def http_get_taxons_by_gi(gi)
    response = HTTParty.get('http://biosql.scilifelab.se/gi/' + gi + '.json')
    taxons = JSON.parse(response)
  end
end
