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
#  hierarchy      :text
#  domain         :string(255)
#  kingdom        :string(255)
#  phylum         :string(255)
#  taxclass       :string(255)
#  taxorder       :string(255)
#  family         :string(255)
#  genus          :string(255)
#  species        :string(255)
#  strain         :string(255)
#

require 'spec_helper'

describe Taxon do
  let!(:taxon_flat) { FactoryGirl.create( :taxon, 
                                     domain: "Bacteria",
                                     kingdom: "Proteobacteria",
                                     phylum: "Alphaproteobacteria",
                                     taxclass: "ClassTax",
                                     taxorder: "OrderTax",
                                     family: "FamilyTax",
                                     genus: "GenusTax",
                                     species: "SpeciesTax",
                                     strain: "StrainTax") }
  let!(:taxon_flat2) { FactoryGirl.create( :taxon, 
                                     domain: "Archaea",
                                     kingdom: "KingdomTax",
                                     phylum: "PhylumTax",
                                     taxclass: "ClassTax",
                                     taxorder: "OrderTax",
                                     family: "FamilyTax",
                                     genus: "GenusTax",
                                     species: "SpeciesTax",
                                     strain: "StrainTax") }
  let!(:taxon) { FactoryGirl.create(:taxon, hierarchy: "root:Bacteria") }
  let!(:taxon2) { FactoryGirl.create(:taxon, 
                                     hierarchy: "root:Bacteria:Proteobacteria", 
                                     parent: taxon) }
  let!(:taxon3) { FactoryGirl.create(:taxon, 
                                     hierarchy: "root:Bacteria:Proteobacteria:Alphaproteobacteria", 
                                     parent: taxon2) }
  let!(:taxon4) { FactoryGirl.create(:taxon, hierarchy: "root:Eukaryota" ) }
  describe "hierarchical order" do
    before do
      @taxons = Taxon.find([taxon_flat.id,taxon_flat2.id], :order => ["domain","kingdom","phylum","taxclass","taxorder","family","genus","species","strain"])
    end
    it "sorts correctly" do
      @taxons.should == [taxon_flat2, taxon_flat]
    end
  end
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
  describe "hierarchy" do
    it "exists" do
      taxon.should respond_to(:hierarchy)
    end
    before do
      @taxons = Taxon.find([taxon4.id,taxon3.id,taxon2.id,taxon.id], :order => 'hierarchy')
    end
    it "sorts correctly" do
      @taxons.should == [taxon, taxon2, taxon3, taxon4]
    end
  end
end
