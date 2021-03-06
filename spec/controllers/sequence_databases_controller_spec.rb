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

describe SequenceDatabasesController do
  before do
    @user = get_admin_user
  end
  # This should return the minimal set of attributes required to create a valid
  # SequenceDatabase. As you add validations to SequenceDatabase, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "db" => "MyString" } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # SequenceDatabasesController. Be sure to keep this updated too.
  let(:valid_session) { {user_id: @user.id} }

  describe "GET index" do
    it "assigns all sequence_databases as @sequence_databases" do
      sequence_database = SequenceDatabase.create! valid_attributes
      get :index, {}, valid_session
      assigns(:sequence_databases).should eq([sequence_database])
    end
  end

  describe "GET show" do
    it "assigns the requested sequence_database as @sequence_database" do
      sequence_database = SequenceDatabase.create! valid_attributes
      get :show, {:id => sequence_database.to_param}, valid_session
      assigns(:sequence_database).should eq(sequence_database)
    end
  end

  describe "GET new" do
    it "assigns a new sequence_database as @sequence_database" do
      get :new, {}, valid_session
      assigns(:sequence_database).should be_a_new(SequenceDatabase)
    end
  end

  describe "GET edit" do
    it "assigns the requested sequence_database as @sequence_database" do
      sequence_database = SequenceDatabase.create! valid_attributes
      get :edit, {:id => sequence_database.to_param}, valid_session
      assigns(:sequence_database).should eq(sequence_database)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new SequenceDatabase" do
        expect {
          post :create, {:sequence_database => valid_attributes}, valid_session
        }.to change(SequenceDatabase, :count).by(1)
      end

      it "assigns a newly created sequence_database as @sequence_database" do
        post :create, {:sequence_database => valid_attributes}, valid_session
        assigns(:sequence_database).should be_a(SequenceDatabase)
        assigns(:sequence_database).should be_persisted
      end

      it "redirects to the created sequence_database" do
        post :create, {:sequence_database => valid_attributes}, valid_session
        response.should redirect_to(SequenceDatabase.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved sequence_database as @sequence_database" do
        # Trigger the behavior that occurs when invalid params are submitted
        SequenceDatabase.any_instance.stub(:save).and_return(false)
        post :create, {:sequence_database => { "db" => "invalid value" }}, valid_session
        assigns(:sequence_database).should be_a_new(SequenceDatabase)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        SequenceDatabase.any_instance.stub(:save).and_return(false)
        post :create, {:sequence_database => { "db" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested sequence_database" do
        sequence_database = SequenceDatabase.create! valid_attributes
        # Assuming there are no other sequence_databases in the database, this
        # specifies that the SequenceDatabase created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        SequenceDatabase.any_instance.should_receive(:update_attributes).with({ "db" => "MyString" })
        put :update, {:id => sequence_database.to_param, :sequence_database => { "db" => "MyString" }}, valid_session
      end

      it "assigns the requested sequence_database as @sequence_database" do
        sequence_database = SequenceDatabase.create! valid_attributes
        put :update, {:id => sequence_database.to_param, :sequence_database => valid_attributes}, valid_session
        assigns(:sequence_database).should eq(sequence_database)
      end

      it "redirects to the sequence_database" do
        sequence_database = SequenceDatabase.create! valid_attributes
        put :update, {:id => sequence_database.to_param, :sequence_database => valid_attributes}, valid_session
        response.should redirect_to(sequence_database)
      end
    end

    describe "with invalid params" do
      it "assigns the sequence_database as @sequence_database" do
        sequence_database = SequenceDatabase.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        SequenceDatabase.any_instance.stub(:save).and_return(false)
        put :update, {:id => sequence_database.to_param, :sequence_database => { "db" => "invalid value" }}, valid_session
        assigns(:sequence_database).should eq(sequence_database)
      end

      it "re-renders the 'edit' template" do
        sequence_database = SequenceDatabase.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        SequenceDatabase.any_instance.stub(:save).and_return(false)
        put :update, {:id => sequence_database.to_param, :sequence_database => { "db" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested sequence_database" do
      sequence_database = SequenceDatabase.create! valid_attributes
      expect {
        delete :destroy, {:id => sequence_database.to_param}, valid_session
      }.to change(SequenceDatabase, :count).by(-1)
    end

    it "redirects to the sequence_databases list" do
      sequence_database = SequenceDatabase.create! valid_attributes
      delete :destroy, {:id => sequence_database.to_param}, valid_session
      response.should redirect_to(sequence_databases_url)
    end
  end

end
