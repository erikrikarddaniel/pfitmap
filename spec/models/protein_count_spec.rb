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
#  loadable_db_id           :integer
#

require 'spec_helper'

describe ProteinCount do
  let!(:hmm_profile) { FactoryGirl.create(:hmm_profile) }
  let!(:protein) { FactoryGirl.create(:protein, hmm_profile: hmm_profile) }
  let!(:sequence_source) { FactoryGirl.create(:sequence_source ) }
  let!(:pfitmap_release) { FactoryGirl.create(:pfitmap_release, sequence_source: sequence_source) }
  let!(:taxon) { FactoryGirl.create(:taxon) }
  let!(:refseq) { FactoryGirl.create(:refseq) }
  let!(:pdb) { FactoryGirl.create(:pdb) }
  let!(:protein_count1) { 
    FactoryGirl.create(:protein_count, taxon: taxon, protein: protein, pfitmap_release: pfitmap_release) 
  }

  subject { protein_count1 }

  it { should respond_to(:no_genomes) }
  it { should respond_to(:no_proteins) }
  it { should respond_to(:no_genomes_with_proteins) }
  it { should respond_to(:protein) }
  it { should respond_to(:pfitmap_release) }
  it { should respond_to(:taxon) }
  it { should respond_to(:loadable_db) }

  it "add a genome" do 
    protein_count1.add_genome
    protein_count1.no_genomes.should == 2
    protein_count1.no_proteins.should == 0
  end
  
  it "adds a hit" do
    protein_count1.obs_as_genome.should == nil
    protein_count1.add_genome
    ProteinCount.add_hit(protein, [taxon], pfitmap_release)
    protein_count = ProteinCount.find(protein_count1.id)
    protein_count.no_genomes.should == 2
    protein_count.no_proteins.should == 1
    protein_count.no_genomes_with_proteins == 1
    protein_count.obs_as_genome.should be(true)
  end

  describe "from_rank" do
    let!(:taxon2) { FactoryGirl.create(:taxon, rank: "genus") }
    10.times do |i|
      protein_count_name = "protein_count" + (i+2).to_s
      let!(protein_count_name.to_sym) { FactoryGirl.create(:protein_count, taxon: taxon2, protein: protein, pfitmap_release: pfitmap_release) }
    end
    it "gives the ones with the right rank back" do
      ProteinCount.from_rank("genus").count.should == 10
      ProteinCount.from_rank(nil).count.should == 11
    end
  end

end
