class ResultRow < ActiveRecord::Base
  belongs_to :result
  has_and_belongs_to_many :sequences
  validates :result_id, presence: true
end
