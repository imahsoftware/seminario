class IglesiasController < ApplicationController
  before_action :set_iglesia, only: [:show, :edit, :update, :destroy]

  # GET /iglesias
  # GET /iglesias.json
  def index
    @iglesias = Iglesia.all
  end

  # GET /iglesias/1
  # GET /iglesias/1.json
  def show
  end

  # GET /iglesias/new
  def new
    @iglesia = Iglesia.new
  end

  # GET /iglesias/1/edit
  def edit
  end

  # POST /iglesias
  # POST /iglesias.json
  def create
    @iglesia = Iglesia.new(iglesia_params)

    respond_to do |format|
      if @iglesia.save
        format.html { redirect_to @iglesia, notice: 'Iglesia was successfully created.' }
        format.json { render :show, status: :created, location: @iglesia }
      else
        format.html { render :new }
        format.json { render json: @iglesia.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /iglesias/1
  # PATCH/PUT /iglesias/1.json
  def update
    respond_to do |format|
      if @iglesia.update(iglesia_params)
        format.html { redirect_to @iglesia, notice: 'Iglesia was successfully updated.' }
        format.json { render :show, status: :ok, location: @iglesia }
      else
        format.html { render :edit }
        format.json { render json: @iglesia.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /iglesias/1
  # DELETE /iglesias/1.json
  def destroy
    @iglesia.destroy
    respond_to do |format|
      format.html { redirect_to iglesias_url, notice: 'Iglesia was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_iglesia
      @iglesia = Iglesia.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def iglesia_params
      params.require(:iglesia).permit(:nombre, :direccion, :telefono, :presbitero, :email, :user_id, :user_act)
    end
end
