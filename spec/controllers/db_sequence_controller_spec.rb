require 'spec_helper'

describe DbSequencesController do

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

  # This should return the minimal set of attributes required to create a valid
  # DbSequence. As you add validations to DbSequence, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end
  
  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # DbSequencesController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all db_sequences as @db_sequences" do
      db_sequence = DbSequence.create! valid_attributes
      get :index, {}, valid_session
      assigns(:db_sequences).should eq([db_sequence])
    end
  end

  describe "GET show" do
    it "assigns the requested db_sequence as @db_sequence" do
      db_sequence = DbSequence.create! valid_attributes
      get :show, {:id => db_sequence.to_param}, valid_session
      assigns(:db_sequence).should eq(db_sequence)
    end
  end

  describe "GET new" do
    it "assigns a new db_sequence as @db_sequence" do
      get :new, {}, valid_session
      assigns(:db_sequence).should be_a_new(DbSequence)
    end
  end

  describe "GET edit" do
    it "assigns the requested db_sequence as @db_sequence" do
      db_sequence = DbSequence.create! valid_attributes
      get :edit, {:id => db_sequence.to_param}, valid_session
      assigns(:db_sequence).should eq(db_sequence)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new DbSequence" do
        expect {
          post :create, {:db_sequence => valid_attributes}, valid_session
        }.to change(DbSequence, :count).by(1)
      end

      it "assigns a newly created db_sequence as @db_sequence" do
        post :create, {:db_sequence => valid_attributes}, valid_session
        assigns(:db_sequence).should be_a(DbSequence)
        assigns(:db_sequence).should be_persisted
      end

      it "redirects to the created db_sequence" do
        post :create, {:db_sequence => valid_attributes}, valid_session
        response.should redirect_to(DbSequence.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved db_sequence as @db_sequence" do
        # Trigger the behavior that occurs when invalid params are submitted
        DbSequence.any_instance.stub(:save).and_return(false)
        post :create, {:db_sequence => {}}, valid_session
        assigns(:db_sequence).should be_a_new(DbSequence)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        DbSequence.any_instance.stub(:save).and_return(false)
        post :create, {:db_sequence => {}}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested db_sequence" do
        db_sequence = DbSequence.create! valid_attributes
        # Assuming there are no other db_sequences in the database, this
        # specifies that the DbSequence created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        DbSequence.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => db_sequence.to_param, :db_sequence => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested db_sequence as @db_sequence" do
        db_sequence = DbSequence.create! valid_attributes
        put :update, {:id => db_sequence.to_param, :db_sequence => valid_attributes}, valid_session
        assigns(:db_sequence).should eq(db_sequence)
      end

      it "redirects to the db_sequence" do
        db_sequence = DbSequence.create! valid_attributes
        put :update, {:id => db_sequence.to_param, :db_sequence => valid_attributes}, valid_session
        response.should redirect_to(db_sequence)
      end
    end

    describe "with invalid params" do
      it "assigns the db_sequence as @db_sequence" do
        db_sequence = DbSequence.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        DbSequence.any_instance.stub(:save).and_return(false)
        put :update, {:id => db_sequence.to_param, :db_sequence => {}}, valid_session
        assigns(:db_sequence).should eq(db_sequence)
      end

      it "re-renders the 'edit' template" do
        db_sequence = DbSequence.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        DbSequence.any_instance.stub(:save).and_return(false)
        put :update, {:id => db_sequence.to_param, :db_sequence => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested db_sequence" do
      db_sequence = DbSequence.create! valid_attributes
      expect {
        delete :destroy, {:id => db_sequence.to_param}, valid_session
      }.to change(DbSequence, :count).by(-1)
    end

    it "redirects to the db_sequences list" do
      db_sequence = DbSequence.create! valid_attributes
      delete :destroy, {:id => db_sequence.to_param}, valid_session
      response.should redirect_to(db_sequences_url)
    end
  end

end
