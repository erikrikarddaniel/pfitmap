# == Schema Information
#
# Table name: hmm_alignments
#
#  id                :integer         not null, primary key
#  hmm_result_row_id :integer
#  score             :float
#  bias              :float
#  evalue            :float
#  ievalue           :float
#  hmmfrom           :integer
#  hmmto             :integer
#  alifrom           :integer
#  alito             :integer
#  envfrom           :integer
#  envto             :integer
#  acc               :float
#  hmm_line          :text
#  match_line        :text
#  target_line       :text
#  pp_line           :text
#  created_at        :datetime        not null
#  updated_at        :datetime        not null
#

class HmmAlignment < ActiveRecord::Base
  attr_accessible :acc, :alifrom, :alito, :bias, :envfrom, :envto, :evalue, :hmm_line, :hmm_result_row_id, :hmmfrom, :hmmto, :ievalue, :match_line, :pp_line, :score, :target_line
  belongs_to :hmm_result_row
  belongs_to :hmm_result
end
