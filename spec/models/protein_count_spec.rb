# == Schema Information
#
# Table name: protein_counts
#
#  id                       :integer         not null, primary key
#  no_genomes               :integer
#  no_proteins              :integer
#  no_genomes_with_proteins :integer
#  protein_id               :integer
#  pfitmap_release_id       :integer
#  taxon_id                 :integer
#  created_at               :datetime        not null
#  updated_at               :datetime        not null
#  obs_as_genome            :boolean
#

require 'spec_helper'

describe ProteinCount do
  pending "add some examples to (or delete) #{__FILE__}"
end
