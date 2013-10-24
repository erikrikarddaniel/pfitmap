class SequenceDatabase < ActiveRecord::Base
  attr_accessible :abbreviation, :accession_url, :db, :home_page
  has_many :db_entries, foreign_key: "db", primary_key: "db"
end
