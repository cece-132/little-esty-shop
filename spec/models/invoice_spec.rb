require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'validations' do
    it { should validate_presence_of :status }
    it { should validate_presence_of :customer_id }
    it { should define_enum_for(:status).with_values(["In Progress", "Completed", "Cancelled"])}

  end

  describe 'relationships' do
    it { should belong_to :customer }
    it { should have_many :invoice_items }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many :transactions }
  end
    
  describe 'factorybot' do
    it 'instantiates with factorybot' do
      customer = create(:customer)
      invoice = customer.invoices.create(attributes_for(:invoice))
      x = create_list(:invoice, 10, customer: customer)
    end

    it 'instantiates without creating parents' do
      invoice = create(:invoice)
      #calling parents: invoice.customer 
    end

    it 'creates a list of invoices belonging to one customer' do
      customer = create(:customer)
      customer_invoices = create_list(:invoice, 10, customer: customer)
    end

    it 'creates a list of 10 customers' do
      customers = create_list(:customer, 10)
    end
  end


  describe 'instance methods' do
    describe 'find_invoice_item_quantity(invoice, item)' do
      it 'can find an instance of invoice_item_quantity' do
          @merchant = create(:merchant)
          @merchant2 = create(:merchant)
          
          @items = create_list(:item, 10, merchant: @merchant)
          @items2 = create_list(:item, 10, merchant: @merchant2)
      
          @customers = create_list(:customer, 2)
          @customer = create(:customer)
      
          @invs_0 = create_list(:invoice, 3, customer: @customers[0]) #
          @invs_1 = create_list(:invoice, 2, customer: @customers[1])
          @invs_2 = create_list(:invoice, 2, customer: @customer)
      
          @inv_item_1 = create(:invoice_item, invoice: @invs_0[0], item: @items[0], quantity: 1) #this will always belong to @merchants[0]
          @inv_item_2 = create(:invoice_item, invoice: @invs_0[1], item: @items[1], quantity: 1) #this will always belong to @merchants[0]
          @inv_item_3 = create(:invoice_item, invoice: @invs_0[2], item: @items[2], quantity: 1) #this will always belong to @merchants[0]      
    
          @inv_item_4 = create(:invoice_item, invoice: @invs_1[1], item: @items[1], quantity: 1) #this will always belong to @merchants[0]      
          @inv_item_5 = create(:invoice_item, invoice: @invs_2[1], item: @items2[6], quantity: 1) #this will always belong to @merchants[0]      

          expect(@invs_0[1].find_invoice_item_quantity(@invs_0[1], @items[1])).to eq 1
      end
    end

    describe 'find_invoice_item_status(invoice, item)' do
      it 'can find an instance of invoice_item_quantity' do
          @merchant = create(:merchant)
          @merchant2 = create(:merchant)
          
          @items = create_list(:item, 10, merchant: @merchant)
          @items2 = create_list(:item, 10, merchant: @merchant2)
      
          @customers = create_list(:customer, 2)
          @customer = create(:customer)
      
          @invs_0 = create_list(:invoice, 3, customer: @customers[0]) #
          @invs_1 = create_list(:invoice, 2, customer: @customers[1])
          @invs_2 = create_list(:invoice, 2, customer: @customer)
      
          @inv_item_1 = create(:invoice_item, invoice: @invs_0[0], item: @items[0], quantity: 1) #this will always belong to @merchants[0]
          @inv_item_2 = create(:invoice_item, invoice: @invs_0[1], item: @items[1], quantity: 1, status: 0) #this will always belong to @merchants[0]
          @inv_item_3 = create(:invoice_item, invoice: @invs_0[2], item: @items[2], quantity: 1) #this will always belong to @merchants[0]      
    
          @inv_item_4 = create(:invoice_item, invoice: @invs_1[1], item: @items[1], quantity: 1) #this will always belong to @merchants[0]      
          @inv_item_5 = create(:invoice_item, invoice: @invs_2[1], item: @items2[6], quantity: 1) #this will always belong to @merchants[0]      

          expect(@invs_0[1].find_invoice_item_status(@invs_0[1], @items[1])).to eq "Pending"
      end
    end

    describe '.revenue' do
      
      before :each do
        @merchant = create(:merchant)

        @customer = create(:customer)
        
        @item = create(:item, merchant: @merchant, unit_price: 100)
        @item_2 = create(:item, merchant: @merchant, unit_price: 100)

        @invoice = create(:invoice, customer: @customer, status: 1)

        @invoice_items = create(:invoice_item, item: @item, invoice: @invoice, unit_price: @item.unit_price, quantity: 1)
        @invoice_items = create(:invoice_item, item: @item_2, invoice: @invoice, unit_price: @item_2.unit_price, quantity: 1)
      end

      it 'can find the sum of each items total revenue for the invoice' do
        expect(@invoice.total_revenue).to eq 200
      end
    end
  end


  describe 'class methods' do
    describe '#incomplete_invoices_sorted' do
      it 'finds invoices that have invoice items that have not been shipped' do
        invoices = create_list(:invoice, 5)
        
        inv_items_0_shipped = create_list(:invoice_item, 5, invoice: invoices[0], status: 2)
       
        inv_items_1_shipped = create_list(:invoice_item, 5, invoice: invoices[1], status: 2)
        inv_items_1_pending= create_list(:invoice_item, 2, invoice: invoices[1], status: 0)
        inv_items_1_packaged = create_list(:invoice_item, 2, invoice: invoices[1], status: 1)

        inv_items_2_shipped = create_list(:invoice_item, 5, invoice: invoices[2], status: 2)

        inv_items_3_pending = create_list(:invoice_item, 5, invoice: invoices[3], status: 0)

        inv_items_4_packaged = create_list(:invoice_item, 5, invoice: invoices[4], status: 1)
        
        expect(Invoice.incomplete_invoices_sorted).to eq([invoices[1], invoices[3], invoices[4]])
      end

      it 'orders invoices with invoice items that have not been shipped by date' do
        oldest_inv = create(:invoice, created_at: Date.yesterday)
        middle_inv = create(:invoice, created_at: Date.today)
        newest_inv = create(:invoice, created_at: Date.tomorrow)

        oldest_inv_items = create_list(:invoice_item, 5, invoice: oldest_inv, status: 1)
        middle_inv_items = create_list(:invoice_item, 5, invoice: middle_inv, status: 0)
        newest_inv_items = create_list(:invoice_item, 5, invoice: newest_inv, status: 1)
        
        expect(Invoice.incomplete_invoices_sorted).to eq([oldest_inv, middle_inv, newest_inv])
      end
    end
  end

  describe 'instance methods' do
    describe '#total_invoice_revenue' do
      it 'calculates the total invoice revenue' do
        invoices = create_list(:invoice, 3)

        inv_items_0 = create_list(:invoice_item, 3, invoice: invoices[0], unit_price: 1000, quantity: 1)
        inv_items_1 = create_list(:invoice_item, 3, invoice: invoices[1], unit_price: 2000, quantity: 2)
        inv_items_2 = create_list(:invoice_item, 3, invoice: invoices[2], unit_price: 3000, quantity: 3)
        
        expect(invoices[0].total_invoice_revenue).to eq(3000)
        expect(invoices[1].total_invoice_revenue).to eq(12000)
        expect(invoices[2].total_invoice_revenue).to eq(27000)
      end
    end

    it 'calculates total invoice revenue in dollars' do
      invoices = create_list(:invoice, 3)

      inv_items_0 = create_list(:invoice_item, 3, invoice: invoices[0], unit_price: 1000, quantity: 1)
      inv_items_1 = create_list(:invoice_item, 3, invoice: invoices[1], unit_price: 2000, quantity: 2)
      inv_items_2 = create_list(:invoice_item, 3, invoice: invoices[2], unit_price: 3000, quantity: 3)
      
      expect(invoices[0].total_invoice_revenue_dollars).to eq(30.00)
      expect(invoices[1].total_invoice_revenue_dollars).to eq(120.00)
      expect(invoices[2].total_invoice_revenue_dollars).to eq(270.00)
    end
  end
end
