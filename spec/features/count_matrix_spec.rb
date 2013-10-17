require 'spec_helper'

describe "ProteinCounts 3 taxa, 2 proteins" do
  let!(:ss)              { FactoryGirl.create(:sequence_source) }
  let!(:pr)              { FactoryGirl.create(:pfitmap_release, current: true, sequence_source: ss) }
  let!(:protA)           { FactoryGirl.create(:protein, protfamily: "protA") }
  let!(:protB)           { FactoryGirl.create(:protein, protfamily: "protB") }
  let!(:taxA)            { FactoryGirl.create(:taxon, domain: "TaxA", pfitmap_release_id: pr.id) }
  let!(:taxB)            { FactoryGirl.create(:taxon, domain: "TaxB", pfitmap_release_id: pr.id) }
  let!(:taxC)            { FactoryGirl.create(:taxon, domain: "TaxC", pfitmap_release_id: pr.id) }
  before do
    @protein_counts = []
    @protein_counts << FactoryGirl.create(:protein_count, no_proteins: 2, no_genomes_with_proteins: 1,  protein: protA, taxon: taxA, pfitmap_release: pr)
    @protein_counts << FactoryGirl.create(:protein_count, no_proteins: 4, no_genomes_with_proteins: 3,  protein: protA, taxon: taxB, pfitmap_release: pr)
    @protein_counts << FactoryGirl.create(:protein_count, no_proteins: 8, no_genomes_with_proteins: 7,  protein: protB, taxon: taxC, pfitmap_release: pr)
  end
  describe "proteins and taxa have correct columns" do
    before do
      make_mock_admin
      login_with_oauth
    end

    it "has three taxa rows and two protein columns", :js => true do
      visit count_matrix_path(params: {})
      page.should have_css("thead")
      page.should have_css("tbody tr", count: 3)
      page.should have_css(".heat_label", count: 6)
      page.should have_css(".protein_label", count: 2)
    end
    it "filter on TaxA and TaxB has two taxa rows and one protein column", :js => true do
      visit count_matrix_path(params: {domain: "TaxA(,)TaxB"})
      page.should have_css("tr.TaxA")
      page.should have_css("tr.TaxB")
      page.should_not have_css("tr.TaxC")
      page.should have_css(".taxon_label", count: 2)
      page.should have_css(".protein_label", count: 1)
      page.should have_css(".heat_label", count: 2)
      page.should have_css(".protA",count: 2)
      page.should_not have_css(".protB")
    end
    it "filter on TaxA and TaxC has two taxa rows and two protein columns with zeros in relative missing protein column", :js => true do
      visit count_matrix_path(params: {domain: "TaxA(,)TaxC"})
      page.should have_css("tr.TaxA")
      page.should have_css("tr.TaxC")
      page.should_not have_css("tr.TaxB")
      page.should have_css(".taxon_label", count: 2)
      page.should have_css(".protein_label", count: 2)
      page.should have_css(".heat_label", count: 4)
      page.should have_css(".protA",count: 2)
      page.should have_css(".protB",count: 2)
    end
    it "filter on TaxA and TaxB and protA and protB has two taxa rows and two protein column", :js => true do
      visit count_matrix_path(params: {domain: "TaxA(,)TaxB", protfamily: "protA(,)protB"})
      page.should have_css("tr.TaxA")
      page.should have_css("tr.TaxB")
      page.should_not have_css("tr.TaxC")
      page.should have_css(".taxon_label", count: 2)
      page.should have_css(".protein_label", count: 2)
      page.should have_css(".heat_label", count: 4)
      page.should have_css(".protA",count: 2)
      page.should have_css(".protB", count: 2)
    end
  end
end
describe "ProteinCounts 2 taxa, 2 proteins" do
  let!(:ss)              { FactoryGirl.create(:sequence_source) }
  let!(:pr)              { FactoryGirl.create(:pfitmap_release, current: true, sequence_source: ss) }
  let!(:protA)           { FactoryGirl.create(:protein, protfamily: "protA") }
  let!(:protB)           { FactoryGirl.create(:protein, protfamily: "protB") }
  let!(:taxA)            { FactoryGirl.create(:taxon, domain: "TaxA", pfitmap_release_id: pr.id) }
  let!(:taxB)            { FactoryGirl.create(:taxon, domain: "TaxB", pfitmap_release_id: pr.id) }
  before do
    @protein_counts = []
    @protein_counts << FactoryGirl.create(:protein_count, no_proteins: 2, no_genomes_with_proteins: 1,  protein: protA, taxon: taxA, pfitmap_release: pr)
    @protein_counts << FactoryGirl.create(:protein_count, no_proteins: 4, no_genomes_with_proteins: 3,  protein: protA, taxon: taxB, pfitmap_release: pr)
    @protein_counts << FactoryGirl.create(:protein_count, no_proteins: 8, no_genomes_with_proteins: 7,  protein: protB, taxon: taxB, pfitmap_release: pr)
  end
  describe "proteins and taxa have correct columns" do
    before do
      make_mock_admin
      login_with_oauth
    end

    it "has two taxa rows and two protein columns", :js => true do
      visit count_matrix_path(params: {})
      page.should have_css("thead")
      page.should have_css("tbody tr", count: 2)
      page.should have_css(".protein_label", count: 2)
      page.should have_css(".heat_label", count: 4)
      page.find(".TaxA").find(".protA").text
      page.find(".TaxA").find(".protB").text.should have_content("0")
      page.find(".TaxB").find(".protA").text.should have_content("4")
      page.find(".TaxB").find(".protB").text.should have_content("8")
    end
  end
end
