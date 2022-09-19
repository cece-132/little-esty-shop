class Invoice < ApplicationRecord
  enum status: ["In Progress", "Completed", "Cancelled"]

  validates_presence_of :status, inclusion: ["In Progress", "Completed", "Cancelled"]
  validates_presence_of :customer_id

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items


  def find_invoice_item_quantity(invoice, item)
    InvoiceItem.find_by(invoice: invoice, item: item).quantity
  end

  def find_invoice_item_status(invoice, item)
    InvoiceItem.find_by(invoice: invoice, item: item).status
  end

  def total_revenue
    items.
    joins(:invoice_items).
    sum('invoice_items.quantity * invoice_items.unit_price')
  end

  def self.incomplete_invoices_sorted
     joins(:invoice_items)
    .distinct
    .where.not("invoice_items.status = ?", 2)
    .order(:created_at)
  end

  def total_invoice_revenue
    items
    .joins(:invoice_items)
    .sum("invoice_items.unit_price * invoice_items.quantity")
  end

  def total_invoice_revenue_dollars 
    total_invoice_revenue.to_f / 100
  end
end