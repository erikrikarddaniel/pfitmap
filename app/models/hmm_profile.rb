# == Schema Information
#
# Table name: hmm_profiles
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  version    :string(255)
#  hierarchy  :string(255)
#  parent_id  :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class HmmProfile < ActiveRecord::Base
  has_many :children, :class_name => "HmmProfile", :foreign_key => "parent_id", :dependent => :destroy
  has_many :hmm_results
  validates :name, presence: true
  validates :version, presence: true
  validates :hierarchy, presence: true
end
