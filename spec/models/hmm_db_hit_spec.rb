# == Schema Information
#
# Table name: hmm_db_hits
#
#  id         :integer         not null, primary key
#  gi         :integer
#  db         :string(255)
#  acc        :string(255)
#  desc       :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe HmmDbHit do
  let(:profile) { FactoryGirl.create(:hmm_profile) }
  let(:result) { FactoryGirl.create(:hmm_result, hmm_profile: profile) }
  let(:result_row) { FactoryGirl.create(:hmm_result_row, hmm_result: result) }
  let(:db_hit) { FactoryGirl.create(:hmm_db_hit) }
  before do
    @db_hit2 = HmmDbHit.new(gi: "99999", db: "ref" , acc: "ex9999", desc: "Some name blabla")
  end

  subject { @db_hit2 }
  
  it { should respond_to(:gi) }
  it { should respond_to(:db) }
  it { should respond_to(:acc ) }
  it { should respond_to(:desc) }
  it { should respond_to(:hmm_result_rows) }
  it { should respond_to(:hmm_result_rows_hmm_db_hits) }
  it { should be_valid }

  describe "should not be valid when gi is not present" do
    before {@db_hit2.gi= nil }
    it { should_not be_valid }
  end
  
  describe "should not be valid when something is not present" do
    pending "More validations?"
  end
  
  describe "with an added relation" do
    before do   
      @relation = HmmResultRowsHmmDbHit.new(hmm_db_hit_id: db_hit.id, hmm_result_row_id: result_row.id)
      @relation.save
    end

    subject { db_hit }
    its(:hmm_result_rows_hmm_db_hits) { should_not be_empty }
    its(:hmm_result_rows_hmm_db_hits) { should include(@relation) }
    its(:hmm_result_rows) { should_not be_empty }
    its(:hmm_result_rows) { should include(result_row) }
  end
end
