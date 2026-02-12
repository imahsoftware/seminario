class IglesiasController < ApplicationController
  before_action :set_iglesia, only: [:show, :edit, :update, :destroy]

  # GET /iglesias
  # GET /iglesias.json
  def index
        @q = Iglesia.ransack(params[:q])
        @iglesias = @q.result.paginate(:page => params[:page], :per_page => 10)
        respond_to do |format|
          format.html
        end
  end

  # GET /iglesias/1
  # GET /iglesias/1.json
  def show
    respond_to { |format| format.js }

  end

  # GET /iglesias/new
  def new
    @iglesia = Iglesia.new
  end

  # GET /iglesias/1/edit
  def edit
    respond_to { |format| format.js }

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
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @iglesia } }
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
