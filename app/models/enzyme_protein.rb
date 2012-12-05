# == Schema Information
#
# Table name: enzyme_proteins
#
#  id         :integer         not null, primary key
#  enzyme_id  :integer
#  protein_id :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class EnzymeProtein < ActiveRecord::Base
  belongs_to :protein
  belongs_to :enzyme
end
