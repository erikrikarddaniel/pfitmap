require 'spec_helper'

describe "ProteinCounts" do
  let!(:sequence_source) { FactoryGirl.create(:sequence_source) }
  let!(:pfitmap_release) { FactoryGirl.create(:pfitmap_release, current: true, sequence_source: sequence_source) }
  let!(:class1) { FactoryGirl.create(:enzyme_class_1) }
  let!(:class1b) { FactoryGirl.create(:enzyme_class_1b, parent: class1) }
  let!(:class2) { FactoryGirl.create(:enzyme_class_2) }
  let!(:class3) { FactoryGirl.create(:enzyme_class_3) }
  let!(:nrdA) { FactoryGirl.create(:protein) }
  let!(:nrdB) { FactoryGirl.create(:protein) }
  let!(:nrdE) { FactoryGirl.create(:protein) }
  let!(:nrdF) { FactoryGirl.create(:protein) }
  let!(:nrdJ) { FactoryGirl.create(:protein) }
  let!(:nrdG) { FactoryGirl.create(:protein) }
  let!(:nrdD) { FactoryGirl.create(:protein) }
  let!(:enzyme_protein1) { FactoryGirl.create(:enzyme_protein, enzyme: class1, protein: nrdA) }
  let!(:enzyme_protein2) { FactoryGirl.create(:enzyme_protein, enzyme: class1, protein: nrdB) }
  let!(:enzyme_protein3) { FactoryGirl.create(:enzyme_protein, enzyme: class1b, protein: nrdE) }
  let!(:enzyme_protein4) { FactoryGirl.create(:enzyme_protein, enzyme: class1b, protein: nrdF) }
  let!(:enzyme_protein5) { FactoryGirl.create(:enzyme_protein, enzyme: class2, protein: nrdJ) }
  let!(:enzyme_protein6) { FactoryGirl.create(:enzyme_protein, enzyme: class3, protein: nrdG) }
  let!(:enzyme_protein7) { FactoryGirl.create(:enzyme_protein, enzyme: class3, protein: nrdD) }


  before do
    50.times do |n|
      FactoryGirl.create(:taxon, rank: "superkingdom", hierarchy: "root:qwerty#{n}")
    end
    @parent_taxon = Taxon.order('hierarchy').first
    20.times do
      FactoryGirl.create(:taxon, rank: "phylum", parent_ncbi_id: @parent_taxon.ncbi_taxon_id)
    end
    @first_child = Taxon.find_by_rank("phylum")
    10.times do
      FactoryGirl.create(:taxon, rank: "class", parent_ncbi_id: @first_child.ncbi_taxon_id)
    end
    @second_child = Taxon.find_by_rank("class")
    Taxon.all.each do |taxon|
      Protein.all.each do |protein|
        FactoryGirl.create(:protein_count, protein: protein, taxon: taxon, pfitmap_release: pfitmap_release)
      end
    end
  end

  describe "with enzymes" do
    before do 
      make_mock_admin
      login_with_oauth
    end
    it "can expand by clicking on taxon name", :js => true do
      visit protein_counts_with_enzymes_path
      page.should_not have_content(@first_child.name)
      page.should have_content(@parent_taxon.name)
      parent_row = find_by_id("taxon#{@parent_taxon.id}")
      within parent_row do
        click_link "+"
      end
      page.should have_content(@first_child.name)
      parent_row = find_by_id("taxon#{@parent_taxon.id}")
      within parent_row do
        click_link "-"
      end
      page.should_not have_content(@first_child.name)
    end
    it "can collapse several levels of taxons", :js => true do
      visit protein_counts_with_enzymes_path
      parent_row = find_by_id("taxon#{@parent_taxon.id}")
      within parent_row do
        click_link "+"
      end
      second_parent_row = find_by_id("taxon#{@first_child.id}")
      within second_parent_row do
        click_link "+"
      end
      page.should have_content(@second_child.name)
      parent_row = find_by_id("taxon#{@parent_taxon.id}")
      #Collapsing grandparent should remove all relatives below"
      within parent_row do
        click_link "-"
      end
      page.should_not have_content(@second_child.name)
    end
    it "only show root enzymes" do
      visit protein_counts_with_enzymes_path
      page.should have_content(class1.name)
      page.should have_content(class2.name)
      page.should have_content(class3.name)
      page.should_not have_content(class1b.name)
    end
  end
end
