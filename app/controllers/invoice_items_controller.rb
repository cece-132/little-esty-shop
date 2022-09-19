class InvoiceItemsController < ApplicationController
  def update
    @invoice_item = InvoiceItem.find_by(item_id: params[:item_id], invoice_id: params[:invoice_id])
    if params[:status]
      @invoice_item.update(invoice_item_params)
      redirect_to merchant_invoice_path(params[:merchant_id], params[:invoice_id])
    end
  end

  private

  def invoice_item_params
    if params[:status] == "Pending"
      params[:status] = 0
    elsif params[:status] == "Packaged"
      params[:status] = 1
    elsif params[:status] == "Shipped"
      params[:status] = 2
    end
    params.permit(:item_id, :invoice_id, :status )
  end
end