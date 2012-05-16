# == Schema Information
#
# Table name: hmm_db_hits
#
#  id             :integer         not null, primary key
#  gi             :integer
#  db             :string(255)
#  acc            :string(255)
#  desc           :string(255)
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#  db_sequence_id :integer
#

class HmmDbHit < ActiveRecord::Base
  attr_accessible :gi, :db, :acc, :desc, :db_sequence_id
  has_many :hmm_result_rows, :through => :db_sequences
  belongs_to :db_sequences
  validates :gi, presence: true
  validates :db_sequence_id, presence: true
end
