class CartController < ApplicationController
  before_action :authenticate_user!

  def show
    @cart_items = session[:cart] || {}
    #@books = Book.where(id: @cart_items.keys)
    @books = Book.all # Fetch all available books
  end

  def checkout
    @cart_items = session[:cart] || {}
    @books = Book.where(id: @cart_items.keys)
    @total_price = calculate_total_price(@books, @cart_items)
  end

  def purchase_history
    @transactions = current_user.transactions.includes(:book)
  end
  private

  def calculate_total_price(books, cart_items)
    books.sum { |book| book.price * cart_items[book.id.to_s].to_i }
  end
end
