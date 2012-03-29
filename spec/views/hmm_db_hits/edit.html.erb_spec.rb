require 'spec_helper'

describe "hmm_db_hits/edit" do
  before(:each) do
    @hmm_db_hit = assign(:hmm_db_hit, stub_model(HmmDbHit,
      :gi => 1,
      :db => "MyString",
      :acc => "MyString",
      :desc => "MyString"
    ))
  end

  it "renders the edit hmm_db_hit form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => hmm_db_hits_path(@hmm_db_hit), :method => "post" do
      assert_select "input#hmm_db_hit_gi", :name => "hmm_db_hit[gi]"
      assert_select "input#hmm_db_hit_db", :name => "hmm_db_hit[db]"
      assert_select "input#hmm_db_hit_acc", :name => "hmm_db_hit[acc]"
      assert_select "input#hmm_db_hit_desc", :name => "hmm_db_hit[desc]"
    end
  end
end
