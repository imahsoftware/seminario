class TiposeventosController < ApplicationController
  before_action :set_tiposevento, only: [:show, :edit, :update, :destroy]

  # GET /tiposeventos
  # GET /tiposeventos.json
  def index
    @tiposeventos = Tiposevento.all
  end

  # GET /tiposeventos/1
  # GET /tiposeventos/1.json
  def show
  end

  # GET /tiposeventos/new
  def new
    @tiposevento = Tiposevento.new
  end

  # GET /tiposeventos/1/edit
  def edit
  end

  # POST /tiposeventos
  # POST /tiposeventos.json
  def create
    @tiposevento = Tiposevento.new(tiposevento_params)

    respond_to do |format|
      if @tiposevento.save
        format.html { redirect_to @tiposevento, notice: 'Tiposevento was successfully created.' }
        format.json { render :show, status: :created, location: @tiposevento }
      else
        format.html { render :new }
        format.json { render json: @tiposevento.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tiposeventos/1
  # PATCH/PUT /tiposeventos/1.json
  def update
    respond_to do |format|
      if @tiposevento.update(tiposevento_params)
        format.html { redirect_to @tiposevento, notice: 'Tiposevento was successfully updated.' }
        format.json { render :show, status: :ok, location: @tiposevento }
      else
        format.html { render :edit }
        format.json { render json: @tiposevento.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tiposeventos/1
  # DELETE /tiposeventos/1.json
  def destroy
    @tiposevento.destroy
    respond_to do |format|
      format.html { redirect_to tiposeventos_url, notice: 'Tiposevento was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tiposevento
      @tiposevento = Tiposevento.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tiposevento_params
      params.require(:tiposevento).permit(:descripcion, :estado, :user_id, :user_act)
    end
end
