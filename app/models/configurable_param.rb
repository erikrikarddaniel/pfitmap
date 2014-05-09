# == Schema Information
#
# Table name: configurable_params
#
#  id         :integer         not null, primary key
#  param      :string(255)
#  value      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class ConfigurableParam < ActiveRecord::Base
  attr_accessible :param, :value
  validates :param, :uniqueness => true
end
