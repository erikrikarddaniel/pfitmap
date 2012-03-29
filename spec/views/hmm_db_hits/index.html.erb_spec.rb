require 'spec_helper'

describe "hmm_db_hits/index" do
  before(:each) do
    assign(:hmm_db_hits, [
      stub_model(HmmDbHit,
        :gi => 1,
        :db => "Db",
        :acc => "Acc",
        :desc => "Desc"
      ),
      stub_model(HmmDbHit,
        :gi => 1,
        :db => "Db",
        :acc => "Acc",
        :desc => "Desc"
      )
    ])
  end

  it "renders a list of hmm_db_hits" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Db".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Acc".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Desc".to_s, :count => 2
  end
end
