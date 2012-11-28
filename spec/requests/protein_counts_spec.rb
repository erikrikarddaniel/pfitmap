require 'spec_helper'

describe "ProteinCounts" do
  let!(:sequence_source) { FactoryGirl.create(:sequence_source) }
  let!(:pfitmap_release) { FactoryGirl.create(:pfitmap_release, current: true, sequence_source: sequence_source) }
  let!(:class1) { FactoryGirl.create(:enzyme_class_1) }
  let!(:class1b) { FactoryGirl.create(:enzyme_class_1b) }
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
    50.times do
      FactoryGirl.create(:taxon, rank: "superkingdom")
    end
    @parent_taxon = Taxon.first 
    20.times do
      FactoryGirl.create(:taxon, rank: "phylum", parent_ncbi_id: @parent_taxon.ncbi_taxon_id)
    end
    @first_child = Taxon.find_by_rank("phylum")
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
    it "works with the sign in", :js => true do
      visit users_path
      save_and_open_page
    end
#    it "displays awesomeness", :js => true do
#      warn "proteins: #{class3.proteins}"
#      class3.proteins.length.should_not == []
#      visit protein_counts_with_enzymes_path
#      click_link "#{@parent_taxon.name}"
#      sleep 5
#      page.should have_content(@first_child.name)
#      save_and_open_page
#    end
  end
end
