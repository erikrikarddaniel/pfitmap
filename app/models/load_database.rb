# == Schema Information
#
# Table name: load_databases
#
#  id                   :integer         not null, primary key
#  taxonset             :string(255)
#  name                 :string(255)
#  description          :string(255)
#  active               :boolean
#  sequence_database_id :integer
#  created_at           :datetime        not null
#  updated_at           :datetime        not null
#

class LoadDatabase < ActiveRecord::Base
  attr_accessible :active, :description, :name, :taxonset, :sequence_database_id
  belongs_to :sequence_database

  def to_s
    "LoadDatabase: #{name}, taxonset: #{taxonset}, sequence_database: #{sequence_database}"
  end
end
