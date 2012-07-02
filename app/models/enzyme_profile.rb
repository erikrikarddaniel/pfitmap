class EnzymeProfile < ActiveRecord::Base
  belongs_to :hmm_profile
  belongs_to :enzyme
end
