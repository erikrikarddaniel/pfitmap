require 'spec_helper'

describe "ProteinCounts 3 taxa, 2 proteins" do
  let!(:ss)              { FactoryGirl.create(:sequence_source) }
  let!(:pr)              { FactoryGirl.create(:pfitmap_release, current: true, sequence_source: ss) }
  let!(:sd)              { FactoryGirl.create(:sequence_database) }
  let!(:ld)              { FactoryGirl.create(:load_database) }
  let!(:rd)              { FactoryGirl.create(:released_db, pfitmap_release_id: pr.id, load_database_id: ld.id) }
  let!(:protA)           { FactoryGirl.create(:protein, protfamily: "protA",released_db_id: rd.id) }
  let!(:protB)           { FactoryGirl.create(:protein, protfamily: "protB",released_db_id: rd.id) }
  let!(:taxA)            { FactoryGirl.create(:taxon, domain: "TaxA", released_db_id: rd.id) }
  let!(:taxB)            { FactoryGirl.create(:taxon, domain: "TaxB", released_db_id: rd.id) }
  let!(:taxC)            { FactoryGirl.create(:taxon, domain: "TaxC", released_db_id: rd.id) }
  before do
    @protein_counts = []
    @protein_counts << FactoryGirl.create(:protein_count, no_proteins: 2, no_genomes_with_proteins: 1,  protein: protA, taxon: taxA, released_db_id: rd.id)
    @protein_counts << FactoryGirl.create(:protein_count, no_proteins: 4, no_genomes_with_proteins: 3,  protein: protA, taxon: taxB, released_db_id: rd.id)
    @protein_counts << FactoryGirl.create(:protein_count, no_proteins: 8, no_genomes_with_proteins: 7,  protein: protB, taxon: taxC, released_db_id: rd.id)
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
  let!(:sd)              { FactoryGirl.create(:sequence_database) }
  let!(:ld)              { FactoryGirl.create(:load_database) }
  let!(:rd)              { FactoryGirl.create(:released_db, pfitmap_release_id: pr.id, load_database_id: ld.id) }
  let!(:protA)           { FactoryGirl.create(:protein, protfamily: "protA",released_db_id: rd.id) }
  let!(:protB)           { FactoryGirl.create(:protein, protfamily: "protB",released_db_id: rd.id) }
  let!(:taxA)            { FactoryGirl.create(:taxon, domain: "TaxA", released_db_id: rd.id) }
  let!(:taxB)            { FactoryGirl.create(:taxon, domain: "TaxB", released_db_id: rd.id) }
  before do
    @protein_counts = []
    @protein_counts << FactoryGirl.create(:protein_count, no_proteins: 2, no_genomes_with_proteins: 1,  protein: protA, taxon: taxA, released_db: rd)
    @protein_counts << FactoryGirl.create(:protein_count, no_proteins: 4, no_genomes_with_proteins: 3,  protein: protA, taxon: taxB, released_db: rd)
    @protein_counts << FactoryGirl.create(:protein_count, no_proteins: 8, no_genomes_with_proteins: 7,  protein: protB, taxon: taxB, released_db: rd)
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
describe "ProteinCounts 4 taxa, 4 proteins" do
  let!(:ss)              { FactoryGirl.create(:sequence_source) }
  let!(:pr)              { FactoryGirl.create(:pfitmap_release, current: true, sequence_source: ss) }
  let!(:sd)              { FactoryGirl.create(:sequence_database) }
  let!(:ld)              { FactoryGirl.create(:load_database) }
  let!(:rd)              { FactoryGirl.create(:released_db, pfitmap_release_id: pr.id, load_database_id: ld.id) }
  let!(:protA)           { FactoryGirl.create(:protein, protfamily: "prot1",protclass: "prot11", released_db_id: rd.id) }
  let!(:protB)           { FactoryGirl.create(:protein, protfamily: "prot1",protclass: "prot12", released_db_id: rd.id) }
  let!(:protC)           { FactoryGirl.create(:protein, protfamily: "prot2",protclass: "prot21", released_db_id: rd.id) }
  let!(:protD)           { FactoryGirl.create(:protein, protfamily: "prot2",protclass: "prot22", released_db_id: rd.id) }
  let!(:taxA)            { FactoryGirl.create(:taxon, domain: "Tax1", kingdom: "Tax11", released_db_id: rd.id) }
  let!(:taxB)            { FactoryGirl.create(:taxon, domain: "Tax1", kingdom: "Tax12", released_db_id: rd.id) }
  let!(:taxC)            { FactoryGirl.create(:taxon, domain: "Tax2", kingdom: "Tax21", released_db_id: rd.id) }
  let!(:taxD)            { FactoryGirl.create(:taxon, domain: "Tax3", kingdom: "Tax31", released_db_id: rd.id) }
  before do
    @protein_counts = []
    @protein_counts << FactoryGirl.create(:protein_count, no_proteins: 2, protein: protA, taxon: taxA, released_db: rd)
    @protein_counts << FactoryGirl.create(:protein_count, no_proteins: 2, protein: protB, taxon: taxA, released_db: rd)
    @protein_counts << FactoryGirl.create(:protein_count, no_proteins: 4, protein: protA, taxon: taxB, released_db: rd)
    @protein_counts << FactoryGirl.create(:protein_count, no_proteins: 8, protein: protB, taxon: taxC, released_db: rd)
    @protein_counts << FactoryGirl.create(:protein_count, no_proteins: 16, protein: protC, taxon: taxD, released_db: rd)
    @protein_counts << FactoryGirl.create(:protein_count, no_proteins: 16, protein: protD, taxon: taxD, released_db: rd)

  end
  describe "proteins and taxa have correct columns" do
    before do
      make_mock_admin
      login_with_oauth
    end

    it "counts n_genomes, n_proteins and n_genomes_w_protein correctly for protfamily", js: true do
      visit count_matrix_path(params: {protein_level: "protfamily", taxon_level: "domain"})
      page.should have_css("thead")
      page.should have_css("tbody tr", count: 3)
      page.should have_css(".protein_label", count: 2)
      page.should have_css(".heat_label", count: 6)
      page.find(".Tax1").find(".prot1").text.should have_content("8")
      page.find(".Tax1").find(".prot2").text.should have_content("0")
      page.find(".Tax2").find(".prot1").text.should have_content("8")
      page.find(".Tax2").find(".prot2").text.should have_content("0")
      page.find(".Tax3").find(".prot1").text.should have_content("0")
      page.find(".Tax3").find(".prot2").text.should have_content("32")
      page.find(".Tax1").find(".no_genomes").text.should have_content("2")
      page.find(".Tax2").find(".no_genomes").text.should have_content("1")
      page.find(".Tax3").find(".no_genomes").text.should have_content("1")
      page.find(".Tax1").find(".prot1").hover
      page.should have_content("Genomes w. proteins: 2")

    end
    it "count n_genomes, n-proteins and n_genomes_w_protein correctly for protclass", js: true do
      visit count_matrix_path(params: {protein_level: "protclass", taxon_level: "domain"})
      page.should have_css("thead")
      page.should have_css("tbody tr", count: 3)
      page.should have_css(".protein_label", count: 4)
      page.should have_css(".heat_label", count: 12)
      page.find(".Tax1").find(".prot11").text.should have_content("6")
      page.find(".Tax1").find(".prot12").text.should have_content("2")
      page.find(".Tax1").find(".prot21").text.should have_content("0")
      page.find(".Tax1").find(".prot22").text.should have_content("0")
      page.find(".Tax2").find(".prot11").text.should have_content("0")
      page.find(".Tax2").find(".prot12").text.should have_content("8")
      page.find(".Tax2").find(".prot21").text.should have_content("0")
      page.find(".Tax2").find(".prot22").text.should have_content("0")
      page.find(".Tax3").find(".prot11").text.should have_content("0")
      page.find(".Tax3").find(".prot12").text.should have_content("0")
      page.find(".Tax3").find(".prot21").text.should have_content("16")
      page.find(".Tax3").find(".prot22").text.should have_content("16")
      page.find(".Tax1").find(".no_genomes").text.should have_content("2")
      page.find(".Tax2").find(".no_genomes").text.should have_content("1")
      page.find(".Tax3").find(".no_genomes").text.should have_content("1")
      page.find(".Tax1").find(".prot11").hover
      page.should have_content("Genomes w. proteins: 2")
    end
  end
end
