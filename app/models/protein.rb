class Protein < ActiveRecord::Base
  belongs_to :HmmProfile
  belongs_to :Enzyme
end
