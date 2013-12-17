# == Schema Information
#
# Table name: hmm_alignments
#
#  id                :integer         not null, primary key
#  hmm_result_row_id :integer
#  score             :float
#  bias              :float
#  cevalue           :float
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
#  domain_num        :integer
#

require 'spec_helper'
require 'file_parsers'

include FileParsers

describe HmmAlignment do
  let(:hmm_result_row) { FactoryGirl.create(:hmm_result_row) }
  before do
    @hmm_alignment = hmm_result_row.hmm_alignments.create(
      score: 365.5,
      cevalue: 6.1e-110,
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
  it { should respond_to(:domain_num) }
  it { should respond_to(:hmm_result_row) }
  it { should respond_to(:hmm_line) }
  it { should respond_to(:match_line) }
  it { should respond_to(:target_line) }
  it { should respond_to(:pp_line) }
  it { should respond_to(:hmm_result) }

  describe "Simple import cases" do
    before(:each) do
      @hmm_result_nrdb = FactoryGirl.create(:hmm_result_nrdb)
      parse_hmm_tblout(@hmm_result_nrdb, fixture_file_upload("/NrdB-20rows.tblout"))
    end

    it "should correctly import a file with a single sequence" do
      parse_hmmout(@hmm_result_nrdb, fixture_file_upload("/NrdB.gi_291295355.hmmout"))
      @hmm_result_nrdb.hmm_alignments.length.should == 1
      a = @hmm_result_nrdb.hmm_alignments.first
      a.hmm_line.should_not == nil
      a.match_line.should_not == nil
      a.target_line.should_not == nil
      a.pp_line.should_not == nil
    end
  end

  describe "Import a single alignment with two domains" do
    before(:each) do
      @hmm_result_nrdb = FactoryGirl.create(:hmm_result_nrdb)
      parse_hmm_tblout(@hmm_result_nrdb, fixture_file_upload("/NrdB.2domains.tblout"))
    end
    
    it "should correctly import it" do
      parse_hmmout(@hmm_result_nrdb, fixture_file_upload("/NrdB.2domains.hmmout"))
      alns = @hmm_result_nrdb.hmm_alignments.sort_by { |n| n.domain_num }
      alns.length.should == 2
      alns[0].hmm_line[0..9] == "kepllsgenl"
      alns[0].hmm_line[-10..-1] == "lleeavelEe"
      alns[1].hmm_line[0..9] == "eeyaedllpe"
      alns[1].hmm_line[-10..-1] == ".ededfdfeg"
    end
  end

  describe "Medium hard import cases" do
    before(:each) do
      @hmm_result_nrdb = FactoryGirl.create(:hmm_result_nrdb)
      parse_hmm_tblout(@hmm_result_nrdb, fixture_file_upload("/NrdB-20rows.tblout"))
    end

    it "should correctly import a file with a single sequence" do
      parse_hmmout(@hmm_result_nrdb, fixture_file_upload("/NrdB-5alignments.hmmout"))
      @hmm_result_nrdb.hmm_alignments.length.should == 5
      @entry1 = DbEntry.find_by_gi(161525957)
      a = @entry1.hmm_alignments.first
      a.domain_num == 1
      a.score.should == 431.4
      a.bias.should == 0.0
      a.cevalue.should == 5.5e-130
      a.ievalue.should == 2.7e-126
      a.hmmfrom.should == 21
      a.hmmto.should == 351
      a.alifrom.should == 58
      a.alito.should == 395
      a.envfrom.should == 15
      a.envto.should == 396
      a.acc.should == 0.96
      a.hmm_line.should == "sqkeeekkepllsgenlsrvnlnpikypwakefykkaeanfWlpeeidlsdDikdWkt...LseeerrlikrvlafltllDtivgenlvealsqeitapeakavlgfqafmEaiHaksYsliletlgtdeeidelFdavrenpalqkKaefvlrlyeslqde.......etkqsll.kllaasvllEgilFYsgFalilalarrgkmkglaeiieliiRDEslHgdfvilliqelleenpelqqkelkeevyelleeavelEeeyaedllpegllglnaedvkqYvryiadkrlmnlGleklfeveaenplpwveailsttkktdFFekrvteYqkagveet"
      a.match_line.should == "+++++++++++++g++ ++++l p+ky+wa+e+y + +an+W+p+ei++s+Di+ Wk+   L+e+err++kr+l+f+ ++D++ ++n+v+ ++++itape++++l +qaf+EaiH+++Y++i+e+lg d  + e+F+a++e+p+++ K+ef+  ++++l+d+       e +q+ll +l+++++++Eg++FY+gF++ilal r++km+g ae++++i+RDEs+H++f+i+li++++ enp+l+++e+++e++el+++avelE +yaed++p+g+lglna+++k+Y+r+i+++r++++Gl++lf++e enp+pw++++++++k+ +FFe+rv eYq++g+ ++"
      a.target_line.should == "EARVNVADKRIINGQT-DVNQLVPFKYKWAWEKYLAGCANHWMPQEINMSRDIALWKDpngLTEDERRIVKRNLGFFVTADSLAANNIVLGTYRHITAPECRQFLLRQAFEEAIHTHAYQYIVESLGLD--EGEIFNAYHEVPSIRAKDEFLIPFIHTLTDPafktgtlEADQKLLkSLIVFACIMEGLFFYVGFTQILALGRQNKMTGAAEQYQYILRDESMHCNFGIDLINQIKLENPHLWTAEFRAEIRELFKQAVELEYRYAEDTMPRGVLGLNASMFKSYLRFICNRRCQQIGLDPLFPNE-ENPFPWMSEMIDLKKERNFFETRVIEYQTGGALSW"
      a.pp_line.should == "67899*******8777.****************************************************************************************************************..**************************************999****9*********************************************************************************************************************************.*******************************9987"
    end
  end
end
