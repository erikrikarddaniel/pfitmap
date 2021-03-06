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

describe EnzymesController do
  before do
    @user = get_admin_user
  end
  # This should return the minimal set of attributes required to create a valid
  # Enzyme. As you add validations to Enzyme, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {
      name: "exname",
      abbreviation: "NNN"
    }
  end
  
  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # EnzymesController. Be sure to keep this updated too.
  def valid_session
    {user_id: @user.id}
  end

  describe "GET index" do
    it "assigns all enzymes as @enzymes" do
      enzyme = Enzyme.create! valid_attributes
      get :index, {}, valid_session
      assigns(:enzymes).should eq([enzyme])
    end
  end

  describe "GET show" do
    it "assigns the requested enzyme as @enzyme" do
      enzyme = Enzyme.create! valid_attributes
      get :show, {:id => enzyme.to_param}, valid_session
      assigns(:enzyme).should eq(enzyme)
    end
  end

  describe "GET new" do
    it "assigns a new enzyme as @enzyme" do
      get :new, {}, valid_session
      assigns(:enzyme).should be_a_new(Enzyme)
    end
  end

  describe "GET edit" do
    it "assigns the requested enzyme as @enzyme" do
      enzyme = Enzyme.create! valid_attributes
      get :edit, {:id => enzyme.to_param}, valid_session
      assigns(:enzyme).should eq(enzyme)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Enzyme" do
        expect {
          post :create, {:enzyme => valid_attributes}, valid_session
        }.to change(Enzyme, :count).by(1)
      end

      it "assigns a newly created enzyme as @enzyme" do
        post :create, {:enzyme => valid_attributes}, valid_session
        assigns(:enzyme).should be_a(Enzyme)
        assigns(:enzyme).should be_persisted
      end

      it "redirects to the created enzyme" do
        post :create, {:enzyme => valid_attributes}, valid_session
        response.should redirect_to(Enzyme.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved enzyme as @enzyme" do
        # Trigger the behavior that occurs when invalid params are submitted
        Enzyme.any_instance.stub(:save).and_return(false)
        post :create, {:enzyme => {}}, valid_session
        assigns(:enzyme).should be_a_new(Enzyme)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Enzyme.any_instance.stub(:save).and_return(false)
        post :create, {:enzyme => {}}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested enzyme" do
        enzyme = Enzyme.create! valid_attributes
        # Assuming there are no other enzymes in the database, this
        # specifies that the Enzyme created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Enzyme.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => enzyme.to_param, :enzyme => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested enzyme as @enzyme" do
        enzyme = Enzyme.create! valid_attributes
        put :update, {:id => enzyme.to_param, :enzyme => valid_attributes}, valid_session
        assigns(:enzyme).should eq(enzyme)
      end

      it "redirects to the enzyme" do
        enzyme = Enzyme.create! valid_attributes
        put :update, {:id => enzyme.to_param, :enzyme => valid_attributes}, valid_session
        response.should redirect_to(enzyme)
      end
    end

    describe "with invalid params" do
      it "assigns the enzyme as @enzyme" do
        enzyme = Enzyme.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Enzyme.any_instance.stub(:save).and_return(false)
        put :update, {:id => enzyme.to_param, :enzyme => {}}, valid_session
        assigns(:enzyme).should eq(enzyme)
      end

      it "re-renders the 'edit' template" do
        enzyme = Enzyme.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Enzyme.any_instance.stub(:save).and_return(false)
        put :update, {:id => enzyme.to_param, :enzyme => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested enzyme" do
      enzyme = Enzyme.create! valid_attributes
      expect {
        delete :destroy, {:id => enzyme.to_param}, valid_session
      }.to change(Enzyme, :count).by(-1)
    end

    it "redirects to the enzymes list" do
      enzyme = Enzyme.create! valid_attributes
      delete :destroy, {:id => enzyme.to_param}, valid_session
      response.should redirect_to(enzymes_url)
    end
  end

end
