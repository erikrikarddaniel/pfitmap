require 'spec_helper'

describe "protein_counts/show" do
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

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
  end
end
