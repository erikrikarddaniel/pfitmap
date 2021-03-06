require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe HmmResultRowsController do
  let!(:hmm_result) { FactoryGirl.create(:hmm_result) }
  let!(:db_sequence) { FactoryGirl.create(:db_sequence) }

  before do
    @user = get_admin_user
  end

  # This should return the minimal set of attributes required to create a valid
  # HmmResultRow. As you add validations to HmmResultRow, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {hmm_result_id: hmm_result.id, 
      db_sequence_id: db_sequence.id}
  end
  
  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # HmmResultRowsController. Be sure to keep this updated too.
  def valid_session
    {user_id: @user.id}
  end

  describe "GET show" do
    it "assigns the requested hmm_result_row as @hmm_result_row" do
      hmm_result_row = HmmResultRow.create! valid_attributes
      get :show, {:id => hmm_result_row.to_param}, valid_session
      assigns(:hmm_result_row).should eq(hmm_result_row)
    end
  end

  describe "GET edit" do
    it "assigns the requested hmm_result_row as @hmm_result_row" do
      hmm_result_row = HmmResultRow.create! valid_attributes
      get :edit, {:id => hmm_result_row.to_param}, valid_session
      assigns(:hmm_result_row).should eq(hmm_result_row)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new HmmResultRow" do
        expect {
          post :create, {:hmm_result_row => valid_attributes}, valid_session
        }.to change(HmmResultRow, :count).by(1)
      end

      it "assigns a newly created hmm_result_row as @hmm_result_row" do
        post :create, {:hmm_result_row => valid_attributes}, valid_session
        assigns(:hmm_result_row).should be_a(HmmResultRow)
        assigns(:hmm_result_row).should be_persisted
      end

      it "redirects to the created hmm_result_row" do
        post :create, {:hmm_result_row => valid_attributes}, valid_session
        response.should redirect_to(HmmResultRow.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved hmm_result_row as @hmm_result_row" do
        # Trigger the behavior that occurs when invalid params are submitted
        HmmResultRow.any_instance.stub(:save).and_return(false)
        post :create, {:hmm_result_row => {}}, valid_session
        assigns(:hmm_result_row).should be_a_new(HmmResultRow)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        HmmResultRow.any_instance.stub(:save).and_return(false)
        post :create, {:hmm_result_row => {}}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested hmm_result_row" do
        hmm_result_row = HmmResultRow.create! valid_attributes
        # Assuming there are no other hmm_result_rows in the database, this
        # specifies that the HmmResultRow created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        HmmResultRow.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => hmm_result_row.to_param, :hmm_result_row => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested hmm_result_row as @hmm_result_row" do
        hmm_result_row = HmmResultRow.create! valid_attributes
        put :update, {:id => hmm_result_row.to_param, :hmm_result_row => valid_attributes}, valid_session
        assigns(:hmm_result_row).should eq(hmm_result_row)
      end

      it "redirects to the hmm_result_row" do
        hmm_result_row = HmmResultRow.create! valid_attributes
        put :update, {:id => hmm_result_row.to_param, :hmm_result_row => valid_attributes}, valid_session
        response.should redirect_to(hmm_result_row)
      end
    end

    describe "with invalid params" do
      it "assigns the hmm_result_row as @hmm_result_row" do
        hmm_result_row = HmmResultRow.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        HmmResultRow.any_instance.stub(:save).and_return(false)
        put :update, {:id => hmm_result_row.to_param, :hmm_result_row => {}}, valid_session
        assigns(:hmm_result_row).should eq(hmm_result_row)
      end

      it "re-renders the 'edit' template" do
        hmm_result_row = HmmResultRow.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        HmmResultRow.any_instance.stub(:save).and_return(false)
        put :update, {:id => hmm_result_row.to_param, :hmm_result_row => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested hmm_result_row" do
      hmm_result_row = HmmResultRow.create! valid_attributes
      expect {
        delete :destroy, {:id => hmm_result_row.to_param}, valid_session
      }.to change(HmmResultRow, :count).by(-1)
    end

    it "redirects to the hmm_result_rows list" do
      hmm_result_row = HmmResultRow.create! valid_attributes
      delete :destroy, {:id => hmm_result_row.to_param}, valid_session
      response.should redirect_to(hmm_result_rows_url)
    end
  end

end
