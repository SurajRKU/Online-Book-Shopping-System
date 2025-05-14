class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, except: [:new, :create, :edit, :update]
  before_action :authorize_admin, except: [:new, :create, :edit, :update] # Allow non-authenticated access to new and create actions, LLM idea
  before_action :check_user_access

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  #def show
  #end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    #redirect_to root_path unless @user == current_user
    @user = User.find(params[:id])
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to users_path, notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    # respond_to do |format|
    #  if @user.update(user_params)
    #    format.html { redirect_to @user, notice: "User was successfully updated." }
    #    format.json { render :show, status: :ok, location: @user }
    #  else
    #    format.html { render :edit, status: :unprocessable_entity }
    #    format.json { render json: @user.errors, status: :unprocessable_entity }
    #  end
    #end
    if @user.update(user_params)
      if current_user.admin?
        redirect_to users_path, notice: "Profile updated successfully."
      else
        redirect_to root_path, notice: "Profile updated successfully. Must re-login with new information."
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    if @user.admin?
      redirect_to users_path, alert: "Admin account cannot be deleted."
    else
      @user.destroy
      respond_to do |format|
        format.html { redirect_to users_path, status: :see_other, notice: "User was successfully destroyed." }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      if current_user.nil? || current_user.admin?
        params.require(:user).permit(:username, :password, :name, :email, :address, :credit_card_number, :phone_number) # Exclude ID, username, password
      else
        params.require(:user).permit(:username, :password, :name, :email, :address, :credit_card_number, :phone_number)
      end
    end

    def authorize_admin
      redirect_to root_path, alert: "Access denied." unless current_user.admin?
    end

    def check_user_access
      @user = User.find(params[:id]) # Adjust if needed based on your routing
    end

    def check_user_access
      if !current_user.nil? && !current_user.admin? && @user != current_user
        redirect_to root_path, alert: "You are not authorized to view this page."
      end
    end

end
