# == Schema Information
#
# Table name: proteins
#
#  id             :integer         not null, primary key
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#  protclass      :string(255)
#  subclass       :string(255)
#  group          :string(255)
#  subgroup       :string(255)
#  subsubgroup    :string(255)
#  protfamily     :string(255)
#  released_db_id :integer
#

require 'spec_helper'

describe Protein do
  let!(:hmm_profile1) { FactoryGirl.create(:hmm_profile) }
  let!(:hmm_profile2) { FactoryGirl.create(:hmm_profile_nrdb) }
  let!(:enzyme1) { FactoryGirl.create(:enzyme_class_1) }
  let!(:enzyme_profile1) { FactoryGirl.create(:enzyme_profile, enzyme: enzyme1, hmm_profile: hmm_profile1) }
  let!(:pfitmap_release) {FactoryGirl.create(:pfitmap_release)}
  let!(:load_database) {FactoryGirl.create(:load_database)}
  let!(:released_db) {FactoryGirl.create(:released_db, pfitmap_release_id: pfitmap_release.id, load_database_id: load_database.id)}
  describe "initialization" do
    describe "with maximum a single enzyme" do
      before do
# TODO        Protein.initialize_proteins
        Protein.create(protfamily: "test",released_db_id: released_db.id)
        @protein = Protein.find(:first)
      end
      it "should have created some proteins" do
        Protein.all.should_not == []
        Protein.count.should == 1
      end
      subject { @protein}
      it {should respond_to(:protfamily)}
      it {should respond_to(:protclass)}
      it {should respond_to(:subclass)}
      it {should respond_to(:group)}
      it {should respond_to(:subgroup)}
      it {should respond_to(:subsubgroup)}
      it {should respond_to(:released_db)}
      it {should_not respond_to(:name) }
      it {should_not respond_to(:rank) }
        
    end
#TODO
#    describe "with multiple enzymes" do
#      let!(:enzyme2) { FactoryGirl.create(:enzyme) }
#      let!(:enzyme_profile2) { FactoryGirl.create(:enzyme_profile, enzyme: enzyme2, hmm_profile: hmm_profile1) }
#      before do
#        Protein.initialize_proteins
#      end
#      it "should have created some proteins" do
#        Protein.all.should_not == []
#        Protein.count.should == 2
#      end
#      it "gets the associations right" do
#        enzyme2.proteins.count.should == 1
#        enzyme1.proteins.count.should == 1
#      end
#    end
    
  end
end
