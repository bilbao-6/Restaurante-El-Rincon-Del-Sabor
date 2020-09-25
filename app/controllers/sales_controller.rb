class SalesController < ApplicationController
  before_action :set_sale, only: [:edit, :destroy]

  def index
    respond_html_and_csv
    @sales = current_user.sales.paginate(page: params[:page], per_page:4)
  end

  def new
    @sale = current_user.sales.new
  end

  def respond_html_and_csv
    respond_to do |format|
      format.html
      format.xlsx do
        response.headers['Content-Disposition'] = 'attachment; filename="Venta.xlsx"'
      end
    end
  end

  def create
    @sale = current_user.sales.new(sale_params)

    respond_to do |format|
      if @sale.save
        format.html { redirect_to sales_url, notice: '  se ha creado'}

        format.json { render :show, status: :created, location: @sale }
      else
        format.html { render :new }
        format.json { render json: @sale.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @sale.destroy
      respond_to do |format|
        format.html { redirect_to sales_url, notice: 'La venta ha sido cancelada.' }
        format.json { head :no_content }
    end
  end

  private

  def set_sale
    @sale = Sale.find(params[:id])
  end

  def sale_params
    params.require(:sale).permit(:total, :client_id)
  end
end
