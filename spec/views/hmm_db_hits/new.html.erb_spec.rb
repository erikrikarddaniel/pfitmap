require 'spec_helper'

describe "hmm_db_hits/new" do
  before(:each) do
    assign(:hmm_db_hit, stub_model(HmmDbHit,
      :gi => 1,
      :db => "MyString",
      :acc => "MyString",
      :desc => "MyString"
    ).as_new_record)
  end

  it "renders new hmm_db_hit form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => hmm_db_hits_path, :method => "post" do
      assert_select "input#hmm_db_hit_gi", :name => "hmm_db_hit[gi]"
      assert_select "input#hmm_db_hit_db", :name => "hmm_db_hit[db]"
      assert_select "input#hmm_db_hit_acc", :name => "hmm_db_hit[acc]"
      assert_select "input#hmm_db_hit_desc", :name => "hmm_db_hit[desc]"
    end
  end
end
