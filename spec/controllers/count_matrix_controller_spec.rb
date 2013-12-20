require 'spec_helper'

describe CountMatrixController do
  def valid_session
    { }
  end

  describe "without data in the database" do
    it "doesn't break" do
      get :get_counts, {}, valid_session
    end
  end

  describe "GET json, domain, protein subclass" do
    before(:each) do
      @released_db = FactoryGirl.create(:released_db)
      @pcs = [ ]
      @pcs << FactoryGirl.create(:e_coli_c227_11_nrdag_protein_count)
      @pcs << FactoryGirl.create(:e_coli_c227_11_nrde_protein_count)
      @pcs << FactoryGirl.create(:e_coli_c227_11_nrddc_protein_count)
      @pcs << FactoryGirl.create(:e_coli_c227_11_nrdbg_protein_count)
      @pcs << FactoryGirl.create(:e_coli_c227_11_nrdf_protein_count)
      @pcs << FactoryGirl.create(:y_pestis_medievalis_nrdag_protein_count)
      @pcs << FactoryGirl.create(:y_pestis_medievalis_nrde_protein_count)
      @pcs << FactoryGirl.create(:y_pestis_medievalis_nrddc_protein_count)
      @pcs << FactoryGirl.create(:y_pestis_medievalis_nrdbg_protein_count)
      @pcs << FactoryGirl.create(:y_pestis_medievalis_nrdf_protein_count)

      # Make sure taxons, proteins and protein_counts has the same released_db_id
      @pcs.each do |pc|
	pc.released_db_id = @released_db.id
	pc.taxon.released_db_id = @released_db.id
	pc.taxon.save
	pc.protein.released_db_id = @released_db.id
	pc.protein.save
	pc.save
      end
    end

    it "is a full matrix with everything ordered correctly" do
      get :get_counts, { format: 'json', protein_level: 'subclass' }, valid_session
      expect(response).to be_success
      json = JSON.parse(response.body)
      prot_columns_in_order = [ 'NrdAg', 'NrdE', 'NrdDc', 'NrdBg', 'NrdF' ]
      response.request.env['gon']['prot_columns'].should == prot_columns_in_order
      json['taxons'][0]['proteins'].map { |p| p['subclass'] }.should == prot_columns_in_order
    end
  end
end
