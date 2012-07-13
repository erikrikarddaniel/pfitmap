require 'spec_helper'

describe "proteins/index" do
  before(:each) do
    assign(:proteins, [
      stub_model(Protein,
        :name => "Name",
        :rank => "Rank",
        :HmmProfile => nil,
        :Enzyme => nil
      ),
      stub_model(Protein,
        :name => "Name",
        :rank => "Rank",
        :HmmProfile => nil,
        :Enzyme => nil
      )
    ])
  end

  it "renders a list of proteins" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Rank".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
