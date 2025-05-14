json.extract! book, :id, :isbn, :name, :author, :publisher, :price, :stock, :created_at, :updated_at
json.url book_url(book, format: :json)
