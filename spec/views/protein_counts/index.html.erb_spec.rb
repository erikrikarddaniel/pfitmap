require 'spec_helper'

describe "protein_counts/index" do
  before(:each) do
    assign(:protein_counts, [
      stub_model(ProteinCount,
        :no_genomes => 1,
        :no_proteins => 1,
        :no_genomes_with_proteins => 1,
        :protein => nil,
        :pfitmap_release => nil,
        :taxon => nil
      ),
      stub_model(ProteinCount,
        :no_genomes => 1,
        :no_proteins => 1,
        :no_genomes_with_proteins => 1,
        :protein => nil,
        :pfitmap_release => nil,
        :taxon => nil
      )
    ])
  end

  it "renders a list of protein_counts" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
