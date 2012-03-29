require 'spec_helper'

describe "hmm_db_hits/show" do
  before(:each) do
    @hmm_db_hit = assign(:hmm_db_hit, stub_model(HmmDbHit,
      :gi => 1,
      :db => "Db",
      :acc => "Acc",
      :desc => "Desc"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Db/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Acc/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Desc/)
  end
end
