require 'spec_helper'

describe BiosqlWeb do
  describe "gi2ncbi_taxon_id" do
    before do
      #Top three from NrdBe-20rows.tblout fixture
      @taxons_ncbi_id1 = BiosqlWeb.gi2ncbi_taxon_id(291295355)
      @taxons_ncbi_id2 = BiosqlWeb.gi2ncbi_taxon_id(158341282)
      @taxons_ncbi_id3 = BiosqlWeb.gi2ncbi_taxon_id(340905392)
    end
    
    it "works" do
      # From the ncbi web
      @taxon_ncbi_id1.should == 504728
      @taxon_ncbi_id2.should == 329726
      @taxon_ncbi_id3.should == 759272
    end
  end

  describe "organism_group_taxon_ncbi_ids" do
    before do
      @wgs_ids = BiosqlWeb.organism_group_taxon_ncbi_ids("GOLDWGStest")
    end

    it "works" do
      @wgs_ids.should include(1000565)
    end
  end

  describe "ncbi_taxon_id2full_taxon_hierarchy" do
    before do
      @taxons1 = BiosqlWeb.ncbi_taxon_id2full_taxon_hierarch(504728)
      @taxons2 = BiosqlWeb.ncbi_taxon_id2full_taxon_hierarch(329726)
      @taxons3 = BiosqlWeb.ncbi_taxon_id2full_taxon_hierarch(759272)
    end
    
    it "works" do
      @taxons1.first["taxon_id"].should == 504728
    end
  end
end
