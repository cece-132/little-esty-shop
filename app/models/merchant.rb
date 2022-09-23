class Merchant < ApplicationRecord
  enum status: ["Enabled", "Disabled"]
  validates_presence_of :name
  validates_presence_of :status, inclusion: ["Enabled", "Disabled"]
  has_many :items
  has_many :bulk_discounts

  def merchant_invoices
    Invoice.joins(:items).where("items.merchant_id = ?", id).distinct
  end

  def self.enabled_merchants
    Merchant.where(status: 0)
  end

  def self.disabled_merchants
    Merchant.where(status: 1)
  end
  
  def items_sorted_by_revenue
    items.
    joins(:invoice_items).
    select('items.*, sum(invoice_items.quantity *invoice_items.unit_price) as revenue').
    group('items.id').
    order(revenue: :desc)
  end

  def top_five_items
    items_sorted_by_revenue.successful_transactions.limit(5)
  end


  def self.top_five_merchants
    Merchant.joins(items:[invoices: :transactions])
    .select("merchants.*, sum(invoice_items.quantity *invoice_items.unit_price) as revenue")
    .where("transactions.result = 0")
    .group(:id)
    .order(revenue: :desc)
    .limit(5)
  end

  def best_selling_day
    items.joins(invoices: :transactions)
    .select("invoices.created_at::DATE as sale_date", "sum(invoice_items.quantity *invoice_items.unit_price) as revenue")
    .where("transactions.result = 0")
    .group(:sale_date)
    .order(revenue: :desc)
    .limit(1)
    .order(sale_date: :desc)
    .first
   end

  def enabled_items
    items.where(status: 0)
  end

  def disabled_items
    items.where(status: 1)
  end

  def self.alpha
    order(:name)
  end
end

