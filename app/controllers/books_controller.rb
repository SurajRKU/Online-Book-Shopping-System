class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_book, only: %i[ show edit update destroy ]


  # GET /books or /books.json
  def index
    @books = Book.all
  end

  # GET /books/1 or /books/1.json
  def show
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
  end

  # POST /books or /books.json
  def create
    @book = Book.new(book_params)

    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: "Book was successfully created." }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1 or /books/1.json
  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to @book, notice: "Book was successfully updated." }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1 or /books/1.json
  def destroy
    @book.destroy!

    respond_to do |format|
      format.html { redirect_to books_path, status: :see_other, notice: "Book was successfully destroyed." }
      format.json { head :no_content }
    end
  end
  # For filtering by average rating
  def filter_by_rating
    if params[:rating].present?
      min_rating = params[:rating].to_f
      # Find books with average rating higher than the given threshold
      @books = Book.joins(:reviews)
                   .group('books.id')
                   .having('AVG(reviews.rating) >= ?', min_rating)
    else
      @books = []
    end
  end
  # For filtering by author
  def filter_by_author
    if params[:author].present?
      author_name = params[:author]
      # Find books by the specified author
      @books = Book.where('author LIKE ?', "%#{author_name}%")
    else
      @books = []
    end
  end
  def add_to_cart
    session[:cart] ||= {}
    book_id = params[:id].to_s

    if Book.find(book_id).stock > (session[:cart][book_id] || 0)
      session[:cart][book_id] = (session[:cart][book_id] || 0) + 1
      flash[:notice] = "Book added to cart."
    else
      flash[:alert] = "There are only #{Book.find(book_id).stock} copies of book #{Book.find(book_id).name} currently in stock."
    end

    redirect_back(fallback_location: books_path)
  end
  def remove_from_cart
    session[:cart] ||= {}
    book_id = params[:id].to_s

    if session[:cart][book_id].to_i > 0
      session[:cart][book_id] -= 1
      flash[:notice] = "Book removed from cart."

      session[:cart].delete(book_id) if session[:cart][book_id].zero?
    else
      flash[:alert] = "No such book in your cart."
    end

    redirect_back(fallback_location: books_path)
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def book_params
      params.require(:book).permit(:isbn, :name, :author, :publisher, :price, :stock)
    end
    def authorize_admin
      redirect_to root_path, alert: "Access denied." unless current_user.admin?
    end
end
