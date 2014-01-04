require 'spec_helper'

describe CountMatrix do
  before(:each) do
    @pf_release = FactoryGirl.create(:pfitmap_release)
  end

  describe 'an object' do
    it 'can be created from a Taxon object' do
      t = FactoryGirl.build(:taxon_escherichia_coli_k12)
      cmt = CountMatrixTaxon.new(t)
      cmt.domain.should == t.domain
      cmt.phylum.should == t.phylum
      cmt.taxclass.should == t.taxclass
      cmt.taxorder.should == t.taxorder
      cmt.taxfamily.should == t.taxfamily
      cmt.genus.should == t.genus
      cmt.species.should == t.species
      cmt.strain.should == t.strain
    end
  end
end
