class EventospersonasController < ApplicationController
  before_action :set_eventospersona, only: [:show, :edit, :update, :destroy]

  # GET /eventospersonas
  # GET /eventospersonas.json
  def index
    @q = Eventospersona.ransack(params[:q])
    @eventospersonas = @q.result.paginate(:page => params[:page], :per_page => 50)
  end

  # GET /eventospersonas/1
  # GET /eventospersonas/1.json
  def show
    respond_to { |format| format.js }

  end

  # GET /eventospersonas/new
  def new
    @eventospersona = Eventospersona.new
  end

  # GET /eventospersonas/1/edit
  def edit
    respond_to { |format| format.js }

  end

  # POST /eventospersonas
  # POST /eventospersonas.json
  def create
    @eventospersona = Eventospersona.new(eventospersona_params)

    respond_to do |format|
      if @eventospersona.save
        format.html { redirect_to @eventospersona, notice: 'Eventospersona was successfully created.' }
        format.json { render :show, status: :created, location: @eventospersona }
      else
        format.html { render :new }
        format.json { render json: @eventospersona.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /eventospersonas/1
  # PATCH/PUT /eventospersonas/1.json
  def update
    respond_to do |format|
      if @eventospersona.update(eventospersona_params)
        format.html { redirect_to @eventospersona, notice: 'Eventospersona was successfully updated.' }
        format.json { render :show, status: :ok, location: @eventospersona }
      else
        format.html { render :edit }
        format.json { render json: @eventospersona.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /eventospersonas/1
  # DELETE /eventospersonas/1.json
  def destroy
    @eventospersona.destroy
    respond_to do |format|
      format.html { redirect_to eventospersonas_url, notice: 'Eventospersona was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_eventospersona
      @eventospersona = Eventospersona.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def eventospersona_params
      params.require(:eventospersona).permit!
    end
end
