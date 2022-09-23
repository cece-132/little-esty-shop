require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :status }
    it { should define_enum_for(:status).with_values(["Enabled", "Disabled"])}
  end

  describe 'relationships' do
    it { should have_many :items}
    it { should have_many :bulk_discounts}
  end



  describe 'class methods' do
    describe '#enabled_merchants' do
      it 'sorts merchants by if their status is enabled' do
        merch1 = Merchant.create!(name: Faker::Movies::VForVendetta.character, status: 0)
        merch2 = Merchant.create!(name: Faker::Movies::VForVendetta.character, status: 1)
        merch3 = Merchant.create!(name: Faker::Movies::VForVendetta.character, status: 0)
        merch4 = Merchant.create!(name: Faker::Movies::VForVendetta.character, status: 1)
        merch5 = Merchant.create!(name: Faker::Movies::VForVendetta.character, status: 0)

        enabled_merchants = [merch1, merch3, merch5]

        expect(Merchant.enabled_merchants).to eq(enabled_merchants)
      end
    end

    describe '#disabled_merchants' do
      it 'sorts merchants by if their status is disabled' do
        merch1 = Merchant.create!(name: Faker::Movies::VForVendetta.character, status: 0)
        merch2 = Merchant.create!(name: Faker::Movies::VForVendetta.character, status: 1)
        merch3 = Merchant.create!(name: Faker::Movies::VForVendetta.character, status: 0)
        merch4 = Merchant.create!(name: Faker::Movies::VForVendetta.character, status: 1)
        merch5 = Merchant.create!(name: Faker::Movies::VForVendetta.character, status: 0)

        disabled_merchants = [merch2, merch4]

        expect(Merchant.disabled_merchants).to eq(disabled_merchants)
      end
    end

    describe '.alpha' do
      it 'orders merchants in alpha order' do
        merch1 = Merchant.create!(name: "Tillies Store")
        merch2 = Merchant.create!(name: "Abby's Store")

        expect(Merchant.alpha).to eq [merch2, merch1]
      end
    end
  end

  describe 'instance methods' do
    describe '#top_five_items' do
      it 'should sort successful transaction items by revenue in desc' do
        merchant1 = Merchant.create!(name: "Mia")

        customer1 = Customer.create!(first_name: "Iron", last_name: "Man")
  
        invoice1 = Invoice.create!(customer_id: customer1.id, status: 1) #completed
        invoice2 = Invoice.create!(customer_id: customer1.id, status: 1) # completed
  
        transaction1 = Transaction.create!(credit_card_number: 948756, result: 1, invoice_id: invoice1.id) #result succesful
        transaction2 = Transaction.create!(credit_card_number: 287502, result: 0, invoice_id: invoice2.id) #result succesful
  
        item1 = Item.create!(name: "Camera", description: "electronic", unit_price: 500, merchant_id: merchant1.id) # 3.
        item2 = Item.create!(name: "Bone", description: "pet treats", unit_price: 200, merchant_id: merchant1.id) # 4.
        item3 = Item.create!(name: "Kong", description: "pet toys", unit_price: 100, merchant_id: merchant1.id) # 5.
        item4 = Item.create!(name: "Collar", description: "pet collar", unit_price: 300, merchant_id: merchant1.id) # 6.
        item5 = Item.create!(name: "Leash", description: "pet leash", unit_price: 400, merchant_id: merchant1.id) # 2.
        item6 = Item.create!(name: "Kibble", description: "pet food", unit_price: 600, merchant_id: merchant1.id) # 1.
  
        invoice_items1 = InvoiceItem.create!(invoice_id: invoice1.id, item_id: item1.id, quantity: 1, unit_price: 500, status: 0) #revenue = 500
        invoice_items2 = InvoiceItem.create!(invoice_id: invoice1.id, item_id: item2.id, quantity: 2, unit_price: 200, status: 0) #revenue = 400
        invoice_items3 = InvoiceItem.create!(invoice_id: invoice1.id, item_id: item3.id, quantity: 3, unit_price: 100, status: 1) #revenue = 300
        invoice_items4 = InvoiceItem.create!(invoice_id: invoice1.id, item_id: item4.id, quantity: 2, unit_price: 100, status: 1) #revenue = 200
        invoice_items5 = InvoiceItem.create!(invoice_id: invoice1.id, item_id: item5.id, quantity: 2, unit_price: 400, status: 2) #revenue = 800
        invoice_items6 = InvoiceItem.create!(invoice_id: invoice2.id, item_id: item6.id, quantity: 2, unit_price: 600, status: 2) #revenue = 1200

        expect(merchant1.items_sorted_by_revenue).to eq [item6, item5, item1, item2, item3, item4]
      end
      it 'should limit to 5 items' do
        merchant1 = Merchant.create!(name: "Mia")

        customer1 = Customer.create!(first_name: "Iron", last_name: "Man")
  
        invoice1 = Invoice.create!(customer_id: customer1.id, status: 1) #completed
        invoice2 = Invoice.create!(customer_id: customer1.id, status: 1) # completed
        invoice3 = Invoice.create!(customer_id: customer1.id, status: 1) # completed
  
        transaction1 = Transaction.create!(credit_card_number: 948756, result: 0, invoice_id: invoice1.id) #result succesful
        transaction2 = Transaction.create!(credit_card_number: 287502, result: 0, invoice_id: invoice2.id) #result succesful
        transaction3 = Transaction.create!(credit_card_number: 287502, result: 1, invoice_id: invoice3.id) #result failure
  
        item1 = Item.create!(name: "Camera", description: "electronic", unit_price: 500, merchant_id: merchant1.id) # 3.
        item2 = Item.create!(name: "Bone", description: "pet treats", unit_price: 200, merchant_id: merchant1.id) # 4.
        item3 = Item.create!(name: "Kong", description: "pet toys", unit_price: 100, merchant_id: merchant1.id) # 5.
        item4 = Item.create!(name: "Collar", description: "pet collar", unit_price: 300, merchant_id: merchant1.id) # 6.
        item5 = Item.create!(name: "Leash", description: "pet leash", unit_price: 400, merchant_id: merchant1.id) # 2.
        item6 = Item.create!(name: "Kibble", description: "pet food", unit_price: 600, merchant_id: merchant1.id) # 1.
        item7 = Item.create!(name: "Failed", description: "Failed", unit_price: 600, merchant_id: merchant1.id) # 1.
  
        invoice_items1 = InvoiceItem.create!(invoice_id: invoice1.id, item_id: item1.id, quantity: 1, unit_price: 500, status: 0) #revenue = 500
        invoice_items2 = InvoiceItem.create!(invoice_id: invoice1.id, item_id: item2.id, quantity: 2, unit_price: 200, status: 0) #revenue = 400
        invoice_items3 = InvoiceItem.create!(invoice_id: invoice1.id, item_id: item3.id, quantity: 3, unit_price: 100, status: 1) #revenue = 300
        invoice_items4 = InvoiceItem.create!(invoice_id: invoice2.id, item_id: item4.id, quantity: 2, unit_price: 100, status: 1) #revenue = 200
        invoice_items5 = InvoiceItem.create!(invoice_id: invoice2.id, item_id: item5.id, quantity: 2, unit_price: 400, status: 2) #revenue = 800
        invoice_items6 = InvoiceItem.create!(invoice_id: invoice2.id, item_id: item6.id, quantity: 2, unit_price: 600, status: 2) #revenue = 1200
        invoice_items7 = InvoiceItem.create!(invoice_id: invoice3.id, item_id: item7.id, quantity: 2, unit_price: 600, status: 2) #revenue = 1200

        expect(merchant1.top_five_items).to eq [item6, item5, item1, item2, item3]
      end
    end


    describe '#Top 5 merchants by revenue' do
      before :each do
        #this makes 500 records in the DB!!!
        @merchants = create_list(:merchant, 10)
        revenue_fix = 0
        transac_result = 0
        @merchants.each do |merchant|
          transac_result = 1 if revenue_fix == 9
          merch_items = create_list(:item, 10, merchant: merchant)
          merch_invoices = create_list(:invoice, 10)
          merch_invoices.each do |merch_invoice|
            create(:transaction, result: transac_result, invoice: merch_invoice)
            create(:transaction, result: 1, invoice: merch_invoice)
          end
          n = 0
          merch_items.each do |merch_item|
            create(:invoice_item, item: merch_item, invoice: merch_invoices[n], unit_price: revenue_fix, quantity: revenue_fix)
            n += 1
          end
          revenue_fix += 1
        end
      end
      it 'should sort successful transaction items by revenue in desc' do
        top_five_merchants = [ @merchants[8], @merchants[7], @merchants[6], @merchants[5], @merchants[4] ]
        expect(Merchant.top_five_merchants).to eq(top_five_merchants)
      end

      it 'should also return each merchants revenue generated' do
        top_five_merchants_revenue  = [ 640, 490, 360, 250, 160]
        revenue_array = Merchant.top_five_merchants.map(&:revenue)
        expect(revenue_array).to eq(top_five_merchants_revenue)
      end

      it 'should also return each merchants id' do
        top_five_merchants_id = [ @merchants[8].id, @merchants[7].id, @merchants[6].id, @merchants[5].id, @merchants[4].id ]
        id_array = Merchant.top_five_merchants.map(&:id)
        expect(id_array).to eq(top_five_merchants_id)
      end
    end

    describe '#best_selling_day' do
      before :each do
        @merchant = create(:merchant)
        merch_items = create_list(:item, 15, merchant: @merchant)
        days = 0
        @merch_invoices = []
        10.times do
          @merch_invoices << create(:invoice, created_at: days.day.ago)
          days += 1
        end
        days = 5
        5.times do
          @merch_invoices << create(:invoice, created_at: days.day.ago)
          days += 1
        end
        transac_result = 0
        @merch_invoices.each do |merch_invoice|
          transac_result = 1 if (merch_invoice == @merch_invoices[9]) || (merch_invoice == @merch_invoices[14])
          #all transactions for the highest revenue day (9.day.ago where n=9) are failed
          create(:transaction, result: transac_result, invoice: merch_invoice)
          create(:transaction, result: 1, invoice: merch_invoice)
          transac_result = 0
        end
        n = 0
        merch_items.each do |merch_item|
          #creates invoice_items with increasing revenue values as the date gets older
          create(:invoice_item, item: merch_item, invoice: @merch_invoices[n], unit_price: n, quantity: n)
          n += 1
        end
      end
      it 'should return highest revenue date with successful transaction items' do
        highest_revenue_day = @merch_invoices[8].created_at.to_date
        expect(@merchant.best_selling_day.sale_date).to eq(highest_revenue_day)
      end

      it 'should also return that days revenue generated' do
        highest_revenue_day_revenue = 
        @merch_invoices[8].total_revenue + @merch_invoices[13].total_revenue
      
        expect(@merchant.best_selling_day.revenue).to eq(highest_revenue_day_revenue)
      end

      it 'returns the most recent invoice if there is a tie' do
        tied_invoice = create(:invoice, created_at: 100.day.ago)
        tied_item = create(:item, merchant: @merchant)
        inv_item_tie = create(:invoice_item, unit_price: 233, quantity: 1, invoice: tied_invoice, item: tied_item)
        
        expect(@merchant.best_selling_day.sale_date).to eq(@merch_invoices[8].created_at.to_date)
      end
    end

  

    describe 'enabled_items' do

      before :each do
        @merchant = create(:merchant)
        @customers = create_list(:customer, 3)
  
        @cus1_invoice = @customers[0].invoices.create(attributes_for(:invoice))
        @cus2_invoice = @customers[1].invoices.create(attributes_for(:invoice))
        @cus3_invoice = @customers[2].invoices.create(attributes_for(:invoice))
       
        @inv1_trans = @cus1_invoice.transactions.create(attributes_for(:transaction, result: 0))
        @inv2_trans = @cus2_invoice.transactions.create(attributes_for(:transaction, result: 0))
        @inv3_trans = @cus3_invoice.transactions.create(attributes_for(:transaction, result: 0))
  
        @item1 = @merchant.items.create(attributes_for(:item, status: 0))
        @item2 = @merchant.items.create(attributes_for(:item, status: 0))
        @item3 = @merchant.items.create(attributes_for(:item, status: 0))
        @item4 = @merchant.items.create(attributes_for(:item, status: 0))
        @item5 = @merchant.items.create(attributes_for(:item, status: 0))
  
        @inv_item1 = create(:invoice_item, invoice_id: @cus1_invoice.id, item_id: @item1.id, quantity: 1, unit_price: @item1.unit_price)
        @inv_item2 = create(:invoice_item, invoice_id: @cus1_invoice.id, item_id: @item2.id, quantity: 1, unit_price: @item2.unit_price)
        @inv_item3 = create(:invoice_item, invoice_id: @cus1_invoice.id, item_id: @item3.id, quantity: 1, unit_price: @item3.unit_price)
        @inv_item4 = create(:invoice_item, invoice_id: @cus1_invoice.id, item_id: @item4.id, quantity: 1, unit_price: @item4.unit_price)
        @inv_item5 = create(:invoice_item, invoice_id: @cus1_invoice.id, item_id: @item5.id, quantity: 1, unit_price: @item5.unit_price)
      end

      it 'can sort the enabled items' do
        expect(@merchant.enabled_items).to eq [@item1, @item2, @item3, @item4, @item5]
      end

    end

    describe 'disabled_items' do

      before :each do
        @merchant = create(:merchant)
        @customers = create_list(:customer, 3)
  
        @cus1_invoice = @customers[0].invoices.create(attributes_for(:invoice))
        @cus2_invoice = @customers[1].invoices.create(attributes_for(:invoice))
        @cus3_invoice = @customers[2].invoices.create(attributes_for(:invoice))
       
        @inv1_trans = @cus1_invoice.transactions.create(attributes_for(:transaction, result: 0))
        @inv2_trans = @cus2_invoice.transactions.create(attributes_for(:transaction, result: 0))
        @inv3_trans = @cus3_invoice.transactions.create(attributes_for(:transaction, result: 0))
  
        @item1 = @merchant.items.create(attributes_for(:item, status: 1))
        @item2 = @merchant.items.create(attributes_for(:item, status: 1))
        @item3 = @merchant.items.create(attributes_for(:item, status: 1))
        @item4 = @merchant.items.create(attributes_for(:item, status: 1))
        @item5 = @merchant.items.create(attributes_for(:item, status: 1))
  
        @inv_item1 = create(:invoice_item, invoice_id: @cus1_invoice.id, item_id: @item1.id, quantity: 1, unit_price: @item1.unit_price)
        @inv_item2 = create(:invoice_item, invoice_id: @cus1_invoice.id, item_id: @item2.id, quantity: 1, unit_price: @item2.unit_price)
        @inv_item3 = create(:invoice_item, invoice_id: @cus1_invoice.id, item_id: @item3.id, quantity: 1, unit_price: @item3.unit_price)
        @inv_item4 = create(:invoice_item, invoice_id: @cus1_invoice.id, item_id: @item4.id, quantity: 1, unit_price: @item4.unit_price)
        @inv_item5 = create(:invoice_item, invoice_id: @cus1_invoice.id, item_id: @item5.id, quantity: 1, unit_price: @item5.unit_price)
      end

      it 'can sort the disabled items' do
        expect(@merchant.disabled_items).to eq [@item1, @item2, @item3, @item4, @item5]
      end

    end
  end

  

  it 'instantiates with Factorybot' do
    merchant = create(:merchant)
  end

  it 'can find invoices that have its items' do
    @merchants = create_list(:merchant, 2)
    
    @items_0 = create_list(:item, 10, merchant: @merchants[0]) #full call to customer @merchants[0].items[0].invoice_items[0].invoice.customer
    @items_1 = create_list(:item, 10, merchant: @merchants[1])

    @customers = create_list(:customer, 2)

    @invs_0 = create_list(:invoice, 3, customer: @customers[0]) #
    @invs_1 = create_list(:invoice, 2, customer: @customers[1])

    @inv_item_1 = create(:invoice_item, invoice: @invs_0[0], item: @items_0[0]) #this will always belong to @merchants[0]
    @inv_item_2 = create(:invoice_item, invoice: @invs_0[1], item: @items_0[1]) #this will always belong to @merchants[0]
    @inv_item_3 = create(:invoice_item, invoice: @invs_0[2], item: @items_0[2]) #this will always belong to @merchants[0]
    
    @inv_item_4 = create(:invoice_item, invoice: @invs_1[0], item: @items_1.sample) #this will always belong to @merchants[1]
    @inv_item_5 = create(:invoice_item, invoice: @invs_1[1], item: @items_1.sample) #this will 
    
    expect(@merchants[0].merchant_invoices).to include(@invs_0[0])
    expect(@merchants[0].merchant_invoices).to include(@invs_0[1])
    expect(@merchants[0].merchant_invoices).to include(@invs_0[2])
    expect(@merchants[0].merchant_invoices).to_not include(@invs_1[0])
  end
end