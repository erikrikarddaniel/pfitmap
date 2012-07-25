# == Schema Information
#
# Table name: taxons
#
#  id             :integer         not null, primary key
#  ncbi_taxon_id  :integer
#  name           :string(255)
#  rank           :string(255)
#  wgs            :boolean
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#  parent_ncbi_id :integer
#

require 'spec_helper'

describe Taxon do
  let!(:taxon) { FactoryGirl.create(:taxon) }
  let!(:taxon2) { FactoryGirl.create(:taxon, parent: taxon) }
  let!(:taxon3) { FactoryGirl.create(:taxon, parent: taxon2) }
  let!(:taxon4) { FactoryGirl.create(:taxon) }
  describe "self_and_ancestors" do
    it "works for bottom level taxon" do
      taxon3.self_and_ancestors.should include(taxon3)
      taxon3.self_and_ancestors.should include(taxon2)
      taxon3.self_and_ancestors.should include(taxon)
      taxon3.self_and_ancestors.should_not include(taxon4)
    end
    it "works for alone taxon" do
      taxon4.self_and_ancestors.should == [taxon4]
    end
  end
  describe "roots" do
    it "finds both roots" do
      Taxon.roots.should include(taxon)
      Taxon.roots.should include(taxon4)
      Taxon.roots.should_not include(taxon3)
      Taxon.roots.should_not include(taxon2)
    end
  end
end
