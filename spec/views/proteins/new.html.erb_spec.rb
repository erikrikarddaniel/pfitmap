require 'spec_helper'

describe "proteins/new" do
  before(:each) do
    assign(:protein, stub_model(Protein,
      :name => "MyString",
      :rank => "MyString",
      :HmmProfile => nil,
      :Enzyme => nil
    ).as_new_record)
  end

  it "renders new protein form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => proteins_path, :method => "post" do
      assert_select "input#protein_name", :name => "protein[name]"
      assert_select "input#protein_rank", :name => "protein[rank]"
      assert_select "input#protein_HmmProfile", :name => "protein[HmmProfile]"
      assert_select "input#protein_Enzyme", :name => "protein[Enzyme]"
    end
  end
end
