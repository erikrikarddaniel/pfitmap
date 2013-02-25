require 'spec_helper'

describe "ProteinCounts" do
  let!(:sequence_source) { FactoryGirl.create(:sequence_source) }
  let!(:pfitmap_release) { FactoryGirl.create(:pfitmap_release, current: true, sequence_source: sequence_source) }
  let!(:class1) 	 { FactoryGirl.create(:enzyme_class_1) }
  let!(:class1b) 	 { FactoryGirl.create(:enzyme_class_1b, parent: class1) }
  let!(:class1x) 	 { FactoryGirl.create(:enzyme_class_1c, parent: class1) }
  let!(:class2) 	 { FactoryGirl.create(:enzyme_class_2) }
  let!(:class3) 	 { FactoryGirl.create(:enzyme_class_3) }
  let!(:nrdA) 		 { FactoryGirl.create(:protein, name: "Nrd A") }
  let!(:nrdB) 		 { FactoryGirl.create(:protein, name: "Nrd B") }
  let!(:nrdE) 		 { FactoryGirl.create(:protein, name: "Nrd E") }
  let!(:nrdF) 		 { FactoryGirl.create(:protein, name: "Nrd F") }
  let!(:nrdJ) 		 { FactoryGirl.create(:protein, name: "Nrd J") }
  let!(:nrdG) 		 { FactoryGirl.create(:protein, name: "Nrd G") }
  let!(:nrdD) 		 { FactoryGirl.create(:protein, name: "Nrd D") }
  let!(:nrdxx) 		 { FactoryGirl.create(:protein, name: "Nrd xx") }
  let!(:nrdyy) 		 { FactoryGirl.create(:protein, name: "Nrd yy") }
  let!(:enzyme_protein1) { FactoryGirl.create(:enzyme_protein, enzyme: class1, protein: nrdA) }
  let!(:enzyme_protein2) { FactoryGirl.create(:enzyme_protein, enzyme: class1, protein: nrdB) }
  let!(:enzyme_protein3) { FactoryGirl.create(:enzyme_protein, enzyme: class1b, protein: nrdE) }
  let!(:enzyme_protein4) { FactoryGirl.create(:enzyme_protein, enzyme: class1b, protein: nrdF) }
  let!(:enzyme_protein8) { FactoryGirl.create(:enzyme_protein, enzyme: class1x, protein: nrdxx) }
  let!(:enzyme_protein9) { FactoryGirl.create(:enzyme_protein, enzyme: class1x, protein: nrdyy) }
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
    @protein_counts = []
    Taxon.all.each_with_index do |taxon, i|
      Protein.all.each_with_index do |protein, j|
        @protein_counts << FactoryGirl.create(:protein_count, no_proteins: ( i + 1 ) * j * 2, no_genomes_with_proteins: ( i + 1 ) * j,  protein: protein, taxon: taxon, pfitmap_release: pfitmap_release)
      end
    end
    @special_count = ProteinCount.find_by_protein_id_and_taxon_id(nrdxx.id,@first_child.id)
    @special_count.no_proteins = 33
    @special_count.save
  end

  describe "with enzymes" do
    before do 
      make_mock_admin
      login_with_oauth
    end

    it "can expand by taxon", :js => true do
      visit protein_counts_with_enzymes_path
      page.should_not have_content(@first_child.name)
      page.should have_content(@parent_taxon.name)
      parent_row = find_by_id("taxon#{@parent_taxon.id}")
      page.should have_css('td.taxon', :count => 30)
      within parent_row do
        click_link "+"
      end
      page.should have_content(@first_child.name)
      page.should have_css('td.taxon', :count => 50)
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
      page.should have_content(class1.abbreviation)
      page.should have_content(class2.abbreviation)
      page.should have_content(class3.abbreviation)
      page.should_not have_content(class1b.abbreviation)
    end

    describe "expand enzyme" do
      it "simply" do
        visit protein_counts_with_enzymes_path
        within("#taxon#{@parent_taxon.id}") do
          page.should have_css('td', :count => 7)
        end
        within("#enzyme#{class1.id}") do
          click_link "+"
        end
        page.should have_content(class1b.abbreviation)
        page.should have_content(class1x.abbreviation)
        page.should_not have_content(class1.proteins.first.name)
        within("#taxon#{@parent_taxon.id}") do
          page.should have_css('td', :count => 9)
        end
      end

      it "without children" do
        visit protein_counts_with_enzymes_path
        within("#enzyme#{class2.id}") do
          click_link "-"
        end
        page.should have_content(class1.abbreviation)
      end

      it "and expand taxon", :js => true do
        visit protein_counts_with_enzymes_path
        within('table.enzyme-header') do
          click_link "+"
        end
        parent_row = find_by_id("taxon#{@parent_taxon.id}")
        within parent_row do
          click_link "+"
        end
        page.should have_content(class1b.abbreviation)
        page.should have_content(class1x.abbreviation)
        page.should_not have_content(class1.proteins.first.name)
        page.should_not have_content("none")
        within("#taxon#{@parent_taxon.id}") do
          page.should have_css('td', :count => 9)
          page.should_not have_content("none")
        end
        page.should have_content(@first_child.name)
        within("#taxon#{@first_child.id}") do
          page.should have_css('td', :count => 9)
          page.should_not have_content("none")
          page.should have_content("33") # From @special_count
          # Should be nice to test the order of the columns 
          # for protein_counts. 
        end
      end
    end
  end
end
