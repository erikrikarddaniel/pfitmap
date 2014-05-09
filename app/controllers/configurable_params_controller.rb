class ConfigurableParamsController < ApplicationController
  load_and_authorize_resource

  # GET /configurable_params
  # GET /configurable_params.json
  def index
    @configurable_params = ConfigurableParam.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @configurable_params }
    end
  end

  # GET /configurable_params/1
  # GET /configurable_params/1.json
  def show
    @configurable_param = ConfigurableParam.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @configurable_param }
    end
  end

  # GET /configurable_params/new
  # GET /configurable_params/new.json
  def new
    @configurable_param = ConfigurableParam.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @configurable_param }
    end
  end

  # GET /configurable_params/1/edit
  def edit
    @configurable_param = ConfigurableParam.find(params[:id])
  end

  # POST /configurable_params
  # POST /configurable_params.json
  def create
    @configurable_param = ConfigurableParam.new(params[:configurable_param])

    respond_to do |format|
      if @configurable_param.save
        format.html { redirect_to @configurable_param, notice: 'Configurable param was successfully created.' }
        format.json { render json: @configurable_param, status: :created, location: @configurable_param }
      else
        format.html { render action: "new" }
        format.json { render json: @configurable_param.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /configurable_params/1
  # PUT /configurable_params/1.json
  def update
    @configurable_param = ConfigurableParam.find(params[:id])

    respond_to do |format|
      if @configurable_param.update_attributes(params[:configurable_param])
        format.html { redirect_to @configurable_param, notice: 'Configurable param was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @configurable_param.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /configurable_params/1
  # DELETE /configurable_params/1.json
  def destroy
    @configurable_param = ConfigurableParam.find(params[:id])
    @configurable_param.destroy

    respond_to do |format|
      format.html { redirect_to configurable_params_url }
      format.json { head :no_content }
    end
  end
end
