class CreateTransactions < ActiveRecord::Migration[7.2]
  def change
    create_table :transactions do |t|
      t.string :transaction_number
      t.integer :book_id
      t.integer :user_id
      t.string :credit_card_number
      t.string :address
      t.string :phone_number
      t.integer :quantity
      t.decimal :total_price

      t.timestamps
    end
  end
end
