require 'csv'

namespace :csv_load do
    desc "Imports Customer CSV file into an ActiveRecord table"

    task :merchants => :environment do
      file = './db/data/merchants.csv'
      CSV.foreach(file, :headers => true) do |row|
        Merchant.create!(row.to_hash)
      end
      ActiveRecord::Base.connection.reset_pk_sequence!(:merchants)
      puts "'Merchants' Complete"
    end

    task :items => :environment do
      file = './db/data/items.csv'
      CSV.foreach(file, :headers => true) do |row|
        Item.create!(row.to_hash)
      end
      ActiveRecord::Base.connection.reset_pk_sequence!(:items)
      puts "'Items' Complete"
    end

    task :customers => :environment do
      file = './db/data/customers.csv'
      CSV.foreach(file, :headers => true) do |row|
        Customer.create!(row.to_hash)
      end
      ActiveRecord::Base.connection.reset_pk_sequence!(:customers)
      puts "'Customers' Complete"
    end

    task :invoices => :environment do
      file = './db/data/invoices.csv'
      CSV.foreach(file, :headers => true) do |row|
        row["status"] = row["status"].titleize
          Invoice.create!(row.to_hash)
      end
      ActiveRecord::Base.connection.reset_pk_sequence!(:invoices)
      puts "'Invoices' Complete"
    end

    task :invoice_items => :environment do
      file = './db/data/invoice_items.csv'
      CSV.foreach(file, :headers => true) do |row|
        row["status"] = row["status"].titleize
        InvoiceItem.create!(row.to_hash)
      end
      ActiveRecord::Base.connection.reset_pk_sequence!(:invoice_items)
      puts "'Invoice Items' Complete"
    end

    task :transactions => :environment do
      file = './db/data/transactions.csv'
      CSV.foreach(file, :headers => true) do |row|
        row["result"] = row["result"].titleize
        Transaction.create!(row.to_hash)
      end
      ActiveRecord::Base.connection.reset_pk_sequence!(:transactions)
      puts "'Transactions' Complete"
    end

    task delete_all: :environment do
      InvoiceItem.destroy_all
      Item.destroy_all
      Merchant.destroy_all
      Transaction.destroy_all
      Invoice.destroy_all
      Customer.destroy_all
      puts "'Delete All' Complete"
    end

    task all: [:merchants, :items, :customers, :invoices, :invoice_items, :transactions]

    desc 'reset all table primary keys'
    task reset_keys: :environment do
      ActiveRecord::Base.connection.tables.each do |table_name|
        ActiveRecord::Base.connection.reset_pk_sequence!(table_name)
      end
  end

end