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

    it 'can add count_matrix_taxon_protein objects via taxon lookup' do
      @cm.taxon(@cmt0).add_protein(@cmt0p0)
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
      end
    end
  end
end
