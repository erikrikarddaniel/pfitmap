# == Schema Information
#
# Table name: taxons
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  rank       :string(255)
#  wgs        :boolean
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Taxon < ActiveRecord::Base
end
