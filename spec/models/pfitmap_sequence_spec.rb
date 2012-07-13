# == Schema Information
#
# Table name: pfitmap_sequences
#
#  id                 :integer         not null, primary key
#  db_sequence_id     :integer
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  pfitmap_release_id :integer
#  hmm_profile_id     :integer
#

require 'spec_helper'

describe PfitmapSequence do
  before do
    @pfitmap_sequence = PfitmapSequence.new()
  end
  subject{@pfitmap_sequence}
  it { should respond_to(:db_sequence) }
  it { should respond_to(:pfitmap_release) }
  it { should respond_to(:calculate_counts) }
  it { should respond_to(:hmm_profile) }
  it { should respond_to(:db_hits_from_ref) }

  describe "db_hits_from_ref" do
    let!(:db_sequence1) { FactoryGirl.create(:db_sequence) }
    let!(:db_sequence2) { FactoryGirl.create(:db_sequence) }
    let!(:hmm_db_hit1) { FactoryGirl.create(:hmm_db_hit, db: "ref", db_sequence: db_sequence1) }
    let!(:hmm_db_hit2) { FactoryGirl.create(:hmm_db_hit, db: "not_ref", db_sequence: db_sequence1) }
    let!(:hmm_db_hit3) { FactoryGirl.create(:hmm_db_hit, db: "ref", db_sequence: db_sequence1) }
    let!(:hmm_db_hit4) { FactoryGirl.create(:hmm_db_hit, db: "ref", db_sequence: db_sequence2) }
    let!(:hmm_db_hit5) { FactoryGirl.create(:hmm_db_hit, db: "ref", db_sequence: db_sequence2) }
    let!(:hmm_db_hit6) { FactoryGirl.create(:hmm_db_hit, db: "not_ref", db_sequence: db_sequence2) }

    let!(:pfitmap_release) { FactoryGirl.create(:pfitmap_release)}
    let!(:pfitmap_sequence1) { FactoryGirl.create(:pfitmap_sequence, db_sequence: db_sequence1, pfitmap_release: pfitmap_release)}
    let!(:pfitmap_sequence2) { FactoryGirl.create(:pfitmap_sequence, db_sequence: db_sequence2, pfitmap_release: pfitmap_release)}
    it "gets it right" do
      pfitmap_sequence1.db_hits_from_ref.should == [hmm_db_hit3, hmm_db_hit1]
      pfitmap_sequence2.db_hits_from_ref.should == [hmm_db_hit5, hmm_db_hit4]
    end
  end
end
