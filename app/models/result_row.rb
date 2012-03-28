class ResultRow < ActiveRecord::Base
  belongs_to :result
  has_and_belongs_to_many :sequences
  has_many :result_rows_sequences
  validates :result_id, presence: true
end
