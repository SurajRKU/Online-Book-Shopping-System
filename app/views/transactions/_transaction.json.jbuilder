json.extract! transaction, :id, :transaction_number, :book_id, :user_id, :credit_card_number, :address, :phone_number, :quantity, :total_price, :created_at, :updated_at
json.url transaction_url(transaction, format: :json)
