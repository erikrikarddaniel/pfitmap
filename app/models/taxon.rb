# == Schema Information
#
# Table name: taxons
#
#  id                 :integer         not null, primary key
#  ncbi_taxon_id      :integer
#  name               :string(255)
#  rank               :string(255)
#  wgs                :boolean
#  pfitmap_release_id :integer
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#

class Taxon < ActiveRecord::Base
end
