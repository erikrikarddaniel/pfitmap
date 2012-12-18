# == Schema Information
#
# Table name: hmm_alignments
#
#  id                :integer         not null, primary key
#  hmm_result_row_id :integer
#  score             :float
#  bias              :float
#  evalue            :float
#  ievalue           :float
#  hmmfrom           :integer
#  hmmto             :integer
#  alifrom           :integer
#  alito             :integer
#  envfrom           :integer
#  envto             :integer
#  acc               :float
#  hmm_line          :text
#  match_line        :text
#  target_line       :text
#  pp_line           :text
#  created_at        :datetime        not null
#  updated_at        :datetime        not null
#

require 'spec_helper'

describe HmmAlignment do
  let(:hmm_result_row) { FactoryGirl.create(:hmm_result_row) }
  before do
    @hmm_alignment = hmm_result_row.hmm_alignments.create(
      score: 365.5,
      evalue: 6.1e-110,
      hmmfrom: 13,
      hmmto: 349,
      alifrom: 3,
      alito: 343,
      envfrom: 1,
      envto: 346,
      acc: 0.98,
      hmm_line:    "kakkleeesqkeeekkepllsgenlsrvnlnpikypwakefykkaeanfWlpeeidlsdDikdWktLseeerrlikrvlafltllDtivgenlvealsqeitapeakavlgfqafmEaiHaksYsliletlgtdeeidelFdavrenpalqkKaef",
      match_line:  "k+k+l++++ + +++ +++  g++++ +++n++ky w+ ++y++a++nfW+peei+ls+D+kd+  L  +er +++++l+fl +lD+i++ nl  ++  +ita+e++ +l+ qaf+E +H++sYs++l+t++++ e++++  +++++++l ++++f",
      target_line: "KKKPLFNPEGDPDVRLRRMTGGNTTNLNDFNNMKYAWVSDWYRQAMNNFWIPEEINLSQDVKDYPRLLSAERSAYDKILSFLVFLDSIQTANLP-NIGAYITANEVNLCLSIQAFQECVHSQSYSYMLDTICSPVERNDILYQWKTDEHLLRRNTF",
      pp_line:     "5667899999999*********************************************************************************.*************************************************************"
    )
  end

  subject { @hmm_alignment }
  it { should respond_to(:hmm_result_row) }
  it { should respond_to(:hmm_line) }
  it { should respond_to(:match_line) }
  it { should respond_to(:target_line) }
  it { should respond_to(:pp_line) }
  it { should respond_to(:hmm_result) }

  describe "Simple import cases" do
    before(:each) do
      @hmm_result_nrdb = FactoryGirl.create(:hmm_result_nrdb)
    end

    it "should correctly import a file with a single sequence" do
      parse_hmm_tblout(@hmm_result_nrdb, fixture_file_upload("/NrdB.test_single_seq.hmmout"))
      @hmm_result_nrdb.hmm_alignments.length.should == 1
    end 
end
