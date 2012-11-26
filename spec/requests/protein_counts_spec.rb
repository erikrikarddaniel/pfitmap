require 'spec_helper'

describe "ProteinCounts" do
  let!(:sequence_source) { FactoryGirl.create(:sequence_source) }
  before do
    make_mock_admin
    login_with_oauth
    @pfitmap_release = PfitmapRelease.new(release: "0.1", release_date: "2001-04-20", sequence_source_id: sequence_source.id)
    @pfitmap_release.current = true
    @pfitmap_release.save
    @hmm_result_nrdb = FactoryGirl.create(:hmm_result_nrdb)
    @sequence_source = @hmm_result_nrdb.sequence_source
    @pfitmap_release = FactoryGirl.create(:pfitmap_release, sequence_source: @sequence_source)
    parse_hmm_tblout(@hmm_result_nrdb, fixture_file_upload("/NrdB-20rows.tblout"))
    @sequence_source.evaluate(@pfitmap_release, nil)
    @pfitmap_release.calculate_main("GOLDWGStest10", FactoryGirl.create(:user_admin))
  end
end
