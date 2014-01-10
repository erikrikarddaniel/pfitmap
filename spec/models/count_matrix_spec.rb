require 'spec_helper'

describe CountMatrix do
  before(:each) do
    @pf_release = FactoryGirl.create(:pfitmap_release)
  end

  describe 'an object' do
    it 'can be created with valid attributes' do
      cm = CountMatrix.new(release: @pf_release.release)
      cm.should be_valid
    end

    it 'is not valid without release' do
      cm = CountMatrix.new
      cm.should_not be_valid
    end

    it 'gets properties set' do
      cm = CountMatrix.new(
	release: @pf_release.release,
	taxon_level: 'Domain',
	protein_level: 'protclass',
	db: 'RefSeq'
      )
      cm.taxon_level.should == 'Domain'
    end
  end

  describe 'via associated count_matrix_taxons' do
    before(:each) do
      @cm = CountMatrix.new(release: @pf_release.release)
      @cmt0 = FactoryGirl.build(:cmt0)
      @cmt1 = FactoryGirl.build(:cmt1)
      @cm.add_taxon(@cmt0)
      @cm.add_taxon(@cmt1)
      @cmt0p0 = FactoryGirl.build(:cmt0p0)
      @cmt0p1 = FactoryGirl.build(:cmt0p1)
      @cmt1p1 = FactoryGirl.build(:cmt1p1)
    end

    it 'can create an associated count_matrix_taxon with valid attributes' do
      @cm.should be_valid
    end

    it 'can add count_matrix_taxon_protein objects via taxon object lookup' do
      @cm.taxon(@cmt0).add_protein(@cmt0p0)
      @cm.taxons.map { |t| t.proteins }.flatten.should == [ @cmt0p0 ]
    end

    it 'can add count_matrix_taxon_protein objects via taxon hierarchy string lookup' do
      @cm.taxon(@cmt0.hierarchy).add_protein(@cmt0p0)
      @cm.taxons.map { |t| t.proteins }.flatten.should == [ @cmt0p0 ]
    end

    describe 'sorted output' do
      it 'can return a sorted matrix with proteins in the correct order' do
	@cm.taxon(@cmt0).add_protein(@cmt0p1)
	@cm.taxon(@cmt0).add_protein(@cmt0p0)
	@cm.taxon(@cmt1).add_protein(@cmt1p1)
	@cm.sort!
	@cm.taxons.should == [ @cmt1, @cmt0 ]
	@cm.taxons[0].proteins.should == [ @cmt1p1 ]
	@cm.taxons[1].proteins.should == [ @cmt0p0, @cmt0p1 ]
	@cm.to_json.should == <<-JSON
{"release":"#{@cm.release}","db":"#{@cm.db}","taxon_level":"#{@cm.taxon_level}","protein_level":"#{@cm.protein_level}","taxon_filter":"#{@cm.taxon_filter}","protein_filter":"#{@cm.protein_filter}","taxons":[
    {"ncbi_taxon_id":#{@cmt1.ncbi_taxon_id},"domain":"#{@cmt1.domain}","kingdom":"#{@cmt1.kingdom}","phylum":"#{@cmt1.phylum}","taxclass":"#{@cmt1.taxclass}","taxorder":"#{@cmt1.taxorder}","taxfamily":"#{@cmt1.taxfamily}","genus":"#{@cmt1.genus}","species":"#{@cmt1.species}","strain":"#{@cmt1.strain}",
      "proteins":[
        {"protfamily":"#{@cmt1p1.protfamily}","protclass":"#{@cmt1p1.protclass}","subclass":"#{@cmt1p1.subclass}","protgroup":"#{@cmt1p1.protgroup}","subgroup":"#{@cmt1p1.subgroup}","subsubgroup":"#{@cmt1p1.subsubgroup}","no_proteins":#{@cmt1p1.no_proteins},"no_genomes_with_proteins":#{@cmt1p1.no_genomes_with_proteins},"all_accessions":"#{@cmt1p1.all_accessions}","counted_accessions":"#{@cmt1p1.counted_accessions}"}

      ]
    }
    ,
    {"ncbi_taxon_id":#{@cmt0.ncbi_taxon_id},"domain":"#{@cmt0.domain}","kingdom":"#{@cmt0.kingdom}","phylum":"#{@cmt0.phylum}","taxclass":"#{@cmt0.taxclass}","taxorder":"#{@cmt0.taxorder}","taxfamily":"#{@cmt0.taxfamily}","genus":"#{@cmt0.genus}","species":"#{@cmt0.species}","strain":"#{@cmt0.strain}",
      "proteins":[
        {"protfamily":"#{@cmt0p0.protfamily}","protclass":"#{@cmt0p0.protclass}","subclass":"#{@cmt0p0.subclass}","protgroup":"#{@cmt0p0.protgroup}","subgroup":"#{@cmt0p0.subgroup}","subsubgroup":"#{@cmt0p0.subsubgroup}","no_proteins":#{@cmt0p0.no_proteins},"no_genomes_with_proteins":#{@cmt0p0.no_genomes_with_proteins},"all_accessions":"#{@cmt0p0.all_accessions}","counted_accessions":"#{@cmt0p0.counted_accessions}"}
    ,
        {"protfamily":"#{@cmt0p1.protfamily}","protclass":"#{@cmt0p1.protclass}","subclass":"#{@cmt0p1.subclass}","protgroup":"#{@cmt0p1.protgroup}","subgroup":"#{@cmt0p1.subgroup}","subsubgroup":"#{@cmt0p1.subsubgroup}","no_proteins":#{@cmt0p1.no_proteins},"no_genomes_with_proteins":#{@cmt0p1.no_genomes_with_proteins},"all_accessions":"#{@cmt0p1.all_accessions}","counted_accessions":"#{@cmt0p1.counted_accessions}"}

      ]
    }

  ]
}
	JSON
      end
    end
  end
end
