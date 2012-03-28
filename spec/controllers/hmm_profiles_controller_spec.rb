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

describe HmmProfilesController do

  # This should return the minimal set of attributes required to create a valid
  # HmmProfile. As you add validations to HmmProfile, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end
  
  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # HmmProfilesController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all hmm_profiles as @hmm_profiles" do
      hmm_profile = HmmProfile.create! valid_attributes
      get :index, {}, valid_session
      assigns(:hmm_profiles).should eq([hmm_profile])
    end
  end

  describe "GET show" do
    it "assigns the requested hmm_profile as @hmm_profile" do
      hmm_profile = HmmProfile.create! valid_attributes
      get :show, {:id => hmm_profile.to_param}, valid_session
      assigns(:hmm_profile).should eq(hmm_profile)
    end
  end

  describe "GET new" do
    it "assigns a new hmm_profile as @hmm_profile" do
      get :new, {}, valid_session
      assigns(:hmm_profile).should be_a_new(HmmProfile)
    end
  end

  describe "GET edit" do
    it "assigns the requested hmm_profile as @hmm_profile" do
      hmm_profile = HmmProfile.create! valid_attributes
      get :edit, {:id => hmm_profile.to_param}, valid_session
      assigns(:hmm_profile).should eq(hmm_profile)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new HmmProfile" do
        expect {
          post :create, {:hmm_profile => valid_attributes}, valid_session
        }.to change(HmmProfile, :count).by(1)
      end

      it "assigns a newly created hmm_profile as @hmm_profile" do
        post :create, {:hmm_profile => valid_attributes}, valid_session
        assigns(:hmm_profile).should be_a(HmmProfile)
        assigns(:hmm_profile).should be_persisted
      end

      it "redirects to the created hmm_profile" do
        post :create, {:hmm_profile => valid_attributes}, valid_session
        response.should redirect_to(HmmProfile.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved hmm_profile as @hmm_profile" do
        # Trigger the behavior that occurs when invalid params are submitted
        HmmProfile.any_instance.stub(:save).and_return(false)
        post :create, {:hmm_profile => {}}, valid_session
        assigns(:hmm_profile).should be_a_new(HmmProfile)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        HmmProfile.any_instance.stub(:save).and_return(false)
        post :create, {:hmm_profile => {}}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested hmm_profile" do
        hmm_profile = HmmProfile.create! valid_attributes
        # Assuming there are no other hmm_profiles in the database, this
        # specifies that the HmmProfile created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        HmmProfile.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => hmm_profile.to_param, :hmm_profile => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested hmm_profile as @hmm_profile" do
        hmm_profile = HmmProfile.create! valid_attributes
        put :update, {:id => hmm_profile.to_param, :hmm_profile => valid_attributes}, valid_session
        assigns(:hmm_profile).should eq(hmm_profile)
      end

      it "redirects to the hmm_profile" do
        hmm_profile = HmmProfile.create! valid_attributes
        put :update, {:id => hmm_profile.to_param, :hmm_profile => valid_attributes}, valid_session
        response.should redirect_to(hmm_profile)
      end
    end

    describe "with invalid params" do
      it "assigns the hmm_profile as @hmm_profile" do
        hmm_profile = HmmProfile.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        HmmProfile.any_instance.stub(:save).and_return(false)
        put :update, {:id => hmm_profile.to_param, :hmm_profile => {}}, valid_session
        assigns(:hmm_profile).should eq(hmm_profile)
      end

      it "re-renders the 'edit' template" do
        hmm_profile = HmmProfile.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        HmmProfile.any_instance.stub(:save).and_return(false)
        put :update, {:id => hmm_profile.to_param, :hmm_profile => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested hmm_profile" do
      hmm_profile = HmmProfile.create! valid_attributes
      expect {
        delete :destroy, {:id => hmm_profile.to_param}, valid_session
      }.to change(HmmProfile, :count).by(-1)
    end

    it "redirects to the hmm_profiles list" do
      hmm_profile = HmmProfile.create! valid_attributes
      delete :destroy, {:id => hmm_profile.to_param}, valid_session
      response.should redirect_to(hmm_profiles_url)
    end
  end

end
