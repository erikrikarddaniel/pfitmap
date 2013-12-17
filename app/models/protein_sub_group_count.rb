# == Schema Information
#
# Table name: protein_sub_group_counts
#
#  domain              :string(255)
#  kingdom             :string(255)
#  phylum              :string(255)
#  taxclass            :string(255)
#  taxorder            :string(255)
#  taxfamily           :string(255)
#  genus               :string(255)
#  species             :string(255)
#  strain              :string(255)
#  protfamily          :string(255)
#  protclass           :string(255)
#  subclass            :string(255)
#  protgroup           :string(255)
#  subgroup            :string(255)
#  released_db_id      :integer
#  all_accessions      :text
#  counted_accessions  :text
#  n_proteins          :integer(8)
#  n_genomes_w_protein :integer
#

class ProteinSubGroupCount < ActiveRecord::Base

end
