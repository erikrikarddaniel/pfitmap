# require 'spec_helper'

# # This spec was generated by rspec-rails when you ran the scaffold generator.
# # It demonstrates how one might use RSpec to specify the controller code that
# # was generated by Rails when you ran the scaffold generator.
# #
# # It assumes that the implementation code is generated by the rails scaffold
# # generator.  If you are using any extension libraries to generate different
# # controller code, this generated spec may or may not pass.
# #
# # It only uses APIs available in rails and/or rspec-rails.  There are a number
# # of tools you can use to make these specs even more expressive, but we're
# # sticking to rails and rspec-rails APIs to keep things simple and stable.
# #
# # Compared to earlier versions of this generator, there is very limited use of
# # stubs and message expectations in this spec.  Stubs are only used when there
# # is no simpler way to get a handle on the object needed for the example.
# # Message expectations are only used when there is no simpler way to specify
# # that an instance is receiving a specific message.

# describe SequenceSourcesController do

#   # This should return the minimal set of attributes required to create a valid
#   # SequenceSource. As you add validations to SequenceSource, be sure to
#   # update the return value of this method accordingly.
#   def valid_attributes
#     {}
#   end
  
#   # This should return the minimal set of values that should be in the session
#   # in order to pass any filters (e.g. authentication) defined in
#   # SequenceSourcesController. Be sure to keep this updated too.
#   def valid_session
#     {}
#   end

#   describe "GET index" do
#     it "assigns all sequence_sources as @sequence_sources" do
#       sequence_source = SequenceSource.create! valid_attributes
#       get :index, {}, valid_session
#       assigns(:sequence_sources).should eq([sequence_source])
#     end
#   end

#   describe "GET show" do
#     it "assigns the requested sequence_source as @sequence_source" do
#       sequence_source = SequenceSource.create! valid_attributes
#       get :show, {:id => sequence_source.to_param}, valid_session
#       assigns(:sequence_source).should eq(sequence_source)
#     end
#   end

#   describe "GET new" do
#     it "assigns a new sequence_source as @sequence_source" do
#       get :new, {}, valid_session
#       assigns(:sequence_source).should be_a_new(SequenceSource)
#     end
#   end

#   describe "GET edit" do
#     it "assigns the requested sequence_source as @sequence_source" do
#       sequence_source = SequenceSource.create! valid_attributes
#       get :edit, {:id => sequence_source.to_param}, valid_session
#       assigns(:sequence_source).should eq(sequence_source)
#     end
#   end

#   describe "POST create" do
#     describe "with valid params" do
#       it "creates a new SequenceSource" do
#         expect {
#           post :create, {:sequence_source => valid_attributes}, valid_session
#         }.to change(SequenceSource, :count).by(1)
#       end

#       it "assigns a newly created sequence_source as @sequence_source" do
#         post :create, {:sequence_source => valid_attributes}, valid_session
#         assigns(:sequence_source).should be_a(SequenceSource)
#         assigns(:sequence_source).should be_persisted
#       end

#       it "redirects to the created sequence_source" do
#         post :create, {:sequence_source => valid_attributes}, valid_session
#         response.should redirect_to(SequenceSource.last)
#       end
#     end

#     describe "with invalid params" do
#       it "assigns a newly created but unsaved sequence_source as @sequence_source" do
#         # Trigger the behavior that occurs when invalid params are submitted
#         SequenceSource.any_instance.stub(:save).and_return(false)
#         post :create, {:sequence_source => {}}, valid_session
#         assigns(:sequence_source).should be_a_new(SequenceSource)
#       end

#       it "re-renders the 'new' template" do
#         # Trigger the behavior that occurs when invalid params are submitted
#         SequenceSource.any_instance.stub(:save).and_return(false)
#         post :create, {:sequence_source => {}}, valid_session
#         response.should render_template("new")
#       end
#     end
#   end

#   describe "PUT update" do
#     describe "with valid params" do
#       it "updates the requested sequence_source" do
#         sequence_source = SequenceSource.create! valid_attributes
#         # Assuming there are no other sequence_sources in the database, this
#         # specifies that the SequenceSource created on the previous line
#         # receives the :update_attributes message with whatever params are
#         # submitted in the request.
#         SequenceSource.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
#         put :update, {:id => sequence_source.to_param, :sequence_source => {'these' => 'params'}}, valid_session
#       end

#       it "assigns the requested sequence_source as @sequence_source" do
#         sequence_source = SequenceSource.create! valid_attributes
#         put :update, {:id => sequence_source.to_param, :sequence_source => valid_attributes}, valid_session
#         assigns(:sequence_source).should eq(sequence_source)
#       end

#       it "redirects to the sequence_source" do
#         sequence_source = SequenceSource.create! valid_attributes
#         put :update, {:id => sequence_source.to_param, :sequence_source => valid_attributes}, valid_session
#         response.should redirect_to(sequence_source)
#       end
#     end

#     describe "with invalid params" do
#       it "assigns the sequence_source as @sequence_source" do
#         sequence_source = SequenceSource.create! valid_attributes
#         # Trigger the behavior that occurs when invalid params are submitted
#         SequenceSource.any_instance.stub(:save).and_return(false)
#         put :update, {:id => sequence_source.to_param, :sequence_source => {}}, valid_session
#         assigns(:sequence_source).should eq(sequence_source)
#       end

#       it "re-renders the 'edit' template" do
#         sequence_source = SequenceSource.create! valid_attributes
#         # Trigger the behavior that occurs when invalid params are submitted
#         SequenceSource.any_instance.stub(:save).and_return(false)
#         put :update, {:id => sequence_source.to_param, :sequence_source => {}}, valid_session
#         response.should render_template("edit")
#       end
#     end
#   end

#   describe "DELETE destroy" do
#     it "destroys the requested sequence_source" do
#       sequence_source = SequenceSource.create! valid_attributes
#       expect {
#         delete :destroy, {:id => sequence_source.to_param}, valid_session
#       }.to change(SequenceSource, :count).by(-1)
#     end

#     it "redirects to the sequence_sources list" do
#       sequence_source = SequenceSource.create! valid_attributes
#       delete :destroy, {:id => sequence_source.to_param}, valid_session
#       response.should redirect_to(sequence_sources_url)
#     end
#   end

# end
