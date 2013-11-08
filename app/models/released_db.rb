# == Schema Information
#
# Table name: released_dbs
#
#  id                 :integer         not null, primary key
#  pfitmap_release_id :integer
#  load_database_id   :integer
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#

class ReleasedDb < ActiveRecord::Base
  attr_accessible :pfitmap_release_id, :load_database_id
  belongs_to :pfitmap_release
  belongs_to :load_database
  has_many :protein_counts, dependent: :destroy
  has_many :taxons, dependent: :destroy
  has_many :proteins, dependent: :destroy
  # attr_accessible :title, :body
end
