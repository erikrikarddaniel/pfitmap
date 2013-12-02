# == Schema Information
#
# Table name: sequence_databases
#
#  id            :integer         not null, primary key
#  db            :string(255)
#  abbreviation  :string(255)
#  home_page     :string(255)
#  accession_url :string(255)
#  created_at    :datetime        not null
#  updated_at    :datetime        not null
#

class SequenceDatabase < ActiveRecord::Base
  attr_accessible :abbreviation, :accession_url, :db, :home_page
  has_many :db_entries, foreign_key: "db", primary_key: "db"
  has_many :load_databases, foreign_key: "sequence_database_id"

  def to_s
    "SequenceDatabase: #{db}"
  end
end
