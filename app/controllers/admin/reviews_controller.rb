class Admin::ReviewsController < ApplicationController
  before_action :set_review, only: [:edit, :update, :destroy, :show]
  before_action :authenticate_user!
  before_action :ensure_admin

  # Display all reviews
  def index
    @reviews = Review.all
  end

  # Show a specific review
  def show

  end

  # New review form for admin
  def new
    @review = Review.new
  end

  # Create a new review
  def create
    user = User.find_by(username: params[:username])
    book = Book.find_by(name: params[:name])

    if user && book
      @review = Review.new(
        user_id: user.id,
        book_id: book.id,
        rating: params[:rating],
        review: params[:review]
      )

      if @review.save
        redirect_to admin_reviews_path, notice: "Review created successfully."
      else
        render :new
      end
    else
      flash.now[:alert] = "Invalid username or book name."
      render :new
    end
  end

  # Edit review form for admin
  def edit
  end

  # Update an existing review
  def update
    if @review.update(review_params)
      redirect_to admin_reviews_path, notice: "Review updated successfully."
    else
      render :edit
    end
  end

  # Delete a review
  def destroy
    @review = Review.find(params[:id]) # Finds the review by its ID
    #ReviewsController.action(:destroy).call(request.env)
    #redirect_to admin_review_path, notice: 'Review deleted successfully by Admin.'
    respond_to do |format|
      if @review.destroy
        format.html { redirect_to admin_reviews_path, notice: 'Review deleted successfully.' }
        format.json { head :no_content }
      else
        format.html { redirect_to admin_reviews_path, alert: 'Failed to delete the review.' }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end

  end

  # List reviews by user
  def list_reviews_by_user
    @user = User.find_by(username: params[:username])
    @reviews = @user.reviews if @user
  end

  # List reviews by book
  def list_reviews_by_book
    @book = Book.find_by(name: params[:book_name])
    @reviews = @book.reviews if @book
  end

  private

  def set_review
    @review = Review.find_by(id: params[:id])
  end

  def review_params
    params.require(:review).permit(:review, :rating, :book_id, :user_id)
  end

  def ensure_admin
    unless current_user.admin?
      redirect_to root_path, alert: "You are not authorized to access this section."
    end
  end

end
