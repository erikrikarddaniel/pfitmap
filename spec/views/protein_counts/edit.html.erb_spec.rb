require 'spec_helper'

describe "protein_counts/edit" do
  before(:each) do
    @protein_count = assign(:protein_count, stub_model(ProteinCount,
      :no_genomes => 1,
      :no_proteins => 1,
      :no_genomes_with_proteins => 1,
      :protein => nil,
      :pfitmap_release => nil,
      :taxon => nil
    ))
  end

  it "renders the edit protein_count form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => protein_counts_path(@protein_count), :method => "post" do
      assert_select "input#protein_count_no_genomes", :name => "protein_count[no_genomes]"
      assert_select "input#protein_count_no_proteins", :name => "protein_count[no_proteins]"
      assert_select "input#protein_count_no_genomes_with_proteins", :name => "protein_count[no_genomes_with_proteins]"
      assert_select "input#protein_count_protein", :name => "protein_count[protein]"
      assert_select "input#protein_count_pfitmap_release", :name => "protein_count[pfitmap_release]"
      assert_select "input#protein_count_taxon", :name => "protein_count[taxon]"
    end
  end
end
