class TransactionsController < ApplicationController
  before_action :authenticate_user!
  #before_action :set_transaction, only: %i[ show edit update destroy ]

  # GET /transactions or /transactions.json
  def index
    @transactions = Transaction.all
  end

  # GET /transactions/1 or /transactions/1.json
  def show
  end
  def create
    cart_items = session[:cart] || {}
    books = Book.where(id: cart_items.keys)

    ActiveRecord::Base.transaction do
      books.each do |book|
        quantity = cart_items[book.id.to_s].to_i
        if book.stock >= quantity && quantity > 0
          Transaction.create!(
            user_id: current_user.id,
            book_id: book.id,
            credit_card_number: current_user.credit_card_number,
            address: current_user.address,
            phone_number: current_user.phone_number,
            quantity: quantity,
            total_price: book.price * quantity
          )
          book.update!(stock: book.stock - quantity)
        else
          flash[:alert] = "Some books are out of stock or invalid quantity"
          redirect_to cart_path and return
        end
      end

      session[:cart] = {}
      flash[:notice] = "Purchase successful!"
      redirect_to purchase_history_cart_path
    end
  rescue ActiveRecord::RecordInvalid => e
    flash[:alert] = "Transaction failed: #{e.message}"
    redirect_to cart_path
  end
  # GET /transactions/new
  def new
    @transaction = Transaction.new
  end

  # GET /transactions/1/edit
  def edit
  end

  # POST /transactions or /transactions.json
  #def create
  #  @transaction = Transaction.new(transaction_params)

  #  respond_to do |format|
  #    if @transaction.save
  #      format.html { redirect_to @transaction, notice: "Transaction was successfully created." }
  #      format.json { render :show, status: :created, location: @transaction }
  #    else
  #      format.html { render :new, status: :unprocessable_entity }
  #      format.json { render json: @transaction.errors, status: :unprocessable_entity }
  #    end
  #  end
  #end

  # PATCH/PUT /transactions/1 or /transactions/1.json
  def update
    respond_to do |format|
      if @transaction.update(transaction_params)
        format.html { redirect_to @transaction, notice: "Transaction was successfully updated." }
        format.json { render :show, status: :ok, location: @transaction }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transactions/1 or /transactions/1.json
  def destroy
    @transaction.destroy!

    respond_to do |format|
      format.html { redirect_to transactions_path, status: :see_other, notice: "Transaction was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transaction
      @transaction = Transaction.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def transaction_params
      params.require(:transaction).permit(:transaction_number, :book_id, :user_id, :credit_card_number, :address, :phone_number, :quantity, :total_price)
    end
end
