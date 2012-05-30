# == Schema Information
#
# Table name: hmm_results
#
#  id                 :integer         not null, primary key
#  executed           :datetime
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  hmm_profile_id     :integer
#  sequence_source_id :integer         not null
#

class HmmResult < ActiveRecord::Base
  attr_accessible :sequence_source_id, :executed
  belongs_to :sequence_source
  belongs_to :hmm_profile
  has_many :hmm_result_rows
  validates :hmm_profile_id, presence: true
  validates :sequence_source_id, presence: true
  validates :hmm_profile_id, :uniqueness => { :scope => :sequence_source_id, :message => "Only one result per combination of HMM Profile and Sequence database!" }
end
