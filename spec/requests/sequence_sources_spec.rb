require 'spec_helper'

describe "SequenceSources" do
  let!(:sequence_source) { FactoryGirl.create(:sequence_source) }
  describe "index" do
    before{visit sequence_sources_path}
    it "displays atleast one source" do
      page.should have_content(sequence_source.name)
    end
  end
  describe "show" do
    before{visit sequence_source_path(sequence_source) }
    it "displays atleast the name" do
      page.should have_content(sequence_source.name)
    end
  end
end
