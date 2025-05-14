class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_review, only: %i[ show edit update destroy ]

  # GET /reviews or /reviews.json
  def index
    @reviews = current_user.reviews
    @purchased_books = Book.joins(:transactions)
                           .where(transactions: { user_id: current_user.id })
                           .distinct
  end

  # GET /reviews/1 or /reviews/1.json
  def show
    @review = Review.find_by(id: params[:id])
    if @review.nil?
      redirect_to books_path, alert: "This review no longer exists or is deleted."
    end
  end

  # GET /reviews/new
  def new
    #@review = Review.new
    @book = Book.find(params[:book_id])
    if current_user.transactions.where(book: @book).exists?
      @review = @book.reviews.build
    else
      redirect_to books_path, alert: "You can only review books you have purchased."
    end
  end

  # GET /reviews/1/edit
  def edit
    @review = Review.find(params[:id])
    if @review.user == current_user
      render :edit
    else
      redirect_to book_path(@review.book), alert: "You can only edit your own reviews."
    end
  end

  # POST /reviews or /reviews.json
  def create
    #@review = Review.new(review_params)

    #respond_to do |format|
    #  if @review.save
    #    format.html { redirect_to @review, notice: "Review was successfully created." }
    #    format.json { render :show, status: :created, location: @review }
    #  else
    #    format.html { render :new, status: :unprocessable_entity }
    #    format.json { render json: @review.errors, status: :unprocessable_entity }
    #  end
    #end
    @book = Book.find(params[:book_id])
    if current_user.transactions.where(book: @book).exists?
      @review = @book.reviews.build(review_params)
      @review.user = current_user
      if @review.save
        redirect_to root_path, notice: "Review added successfully."
      else
        render :new
      end
    else
      redirect_to root_path, alert: "You cannot review this book."
    end
  end

  # PATCH/PUT /reviews/1 or /reviews/1.json
  def update
    if @review.user == current_user
      if @review.update(review_params)
        redirect_to reviews_path, notice: "Review updated successfully."
      else
        render :edit
      end
    else
      redirect_to reviews_path, alert: "You can only update your review."
    end

  end
  def reviews_by_user
    #@user = User.find(params[:user_id])
    #@reviews = @user.reviews
    if params[:user_id].present?
      user_id = params[:user_id]
      @user = User.find_by(id: user_id) || User.find_by(username: user_id) # Find by ID or username

      if @user
        @reviews = @user.reviews
      else
        flash[:alert] = "User not found."
        redirect_to root_path
      end
    else
      flash[:alert] = "Please Enter Username."
      redirect_to root_path and return
    end
  end
  def reviews_by_book
    #@book = Book.find(params[:book_id])
    #@reviews = @book.reviews
    if params[:book_name].present?
      # Find the book by name (case insensitive)
      @book = Book.where('LOWER(name) = ?', params[:book_name].downcase).first

      if @book
        # If the book is found, retrieve its reviews using book_id
        @reviews = Review.where(book_id: @book.id)
      else
        flash[:alert] = "Book not found."
        redirect_to root_path and return # Prevent further processing
      end
    else
      flash[:alert] = "Please provide a book name."
      redirect_to root_path and return # Prevent further processing
    end
  end

  # DELETE /reviews/1 or /reviews/1.json
  def destroy
    @review.destroy!

    respond_to do |format|
      format.html { redirect_to reviews_path, status: :see_other, notice: "Review was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_review
      @review = Review.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def review_params
      params.require(:review).permit(:book_id, :user_id, :rating, :review)
    end
end
