require 'spec_helper'

describe BiosqlWeb do
  describe "gi2ncbi_taxon_id" do
    before do
      #Top three from NrdBe-20rows.tblout fixture
      @taxon_ncbi_id1 = BiosqlWeb.gi2ncbi_taxon_id(291295355)
      @taxon_ncbi_id2 = BiosqlWeb.gi2ncbi_taxon_id(158341282)
      @taxon_ncbi_id3 = BiosqlWeb.gi2ncbi_taxon_id(340905392)
      @taxon_ncbi_id4 = BiosqlWeb.gi2ncbi_taxon_id(4557845)
    end

    it "works" do
      # From the ncbi web
      @taxon_ncbi_id1.should == 504728
      @taxon_ncbi_id2.should == 329726
      @taxon_ncbi_id3.should == 759272
      @taxon_ncbi_id4.should == 9606
    end
  end

  describe "organism_group2ncbi_taxon_ids" do
    before do
      @wgs_ids = BiosqlWeb.organism_group2ncbi_taxon_ids("GOLDWGStest10")
    end

    it "works" do
      @wgs_ids.should include(1000565)
      @wgs_ids.length.should == 10
    end
  end

  describe "ncbi_taxon_id2full_taxon_hierarchy" do
    before do
      @taxons1 = BiosqlWeb.ncbi_taxon_id2full_taxon_hierarchy(504728)
      @taxons2 = BiosqlWeb.ncbi_taxon_id2full_taxon_hierarchy(329726)
      @taxons3 = BiosqlWeb.ncbi_taxon_id2full_taxon_hierarchy(759272)
    end
    
    it "works" do
      @taxons1.first["ncbi_taxon_id"].should == 504728
      @taxons1.last["scientific_name"].should == "root"
    end
  end
end
