# == Schema Information
#
# Table name: taxons
#
#  id             :integer         not null, primary key
#  ncbi_taxon_id  :integer
#  name           :string(255)
#  rank           :string(255)
#  wgs            :boolean
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#  parent_ncbi_id :integer
#

class Taxon < ActiveRecord::Base
  # The hierarchy association uses ncbi_ids to make it easier to construct from retrieved data
  belongs_to :parent, :class_name => "Taxon", :foreign_key => "parent_ncbi_id", :primary_key => "ncbi_taxon_id"
  has_many :children, :class_name => "Taxon", :foreign_key => "parent_ncbi_id", :primary_key => "ncbi_taxon_id"

end
