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
  belongs_to :parent, :class_name => "HmmProfile", :foreign_key => "parent_id"
  has_many :hmm_results
  validates :name, presence: true
  validates :version, presence: true
  validates :hierarchy, presence: true
  def last_parent_id()
    last_parent_recursion(self.id)
  end
  def all_children()
    
  end
  
  private
  def last_parent_recursion(id)
    parent = HmmProfile.find(id)
    if parent.parent_id == nil
      return id
    else
      last_parent_recursion(parent.parent_id)
    end
  end
end
