require 'rails_helper'

RSpec.describe BooksController, type: :controller do
  #let(:admin) { create(:admin) }
  let!(:book) { create(:book) }

  #before do
  #  sign_in admin
  #end

  describe "GET #index" do
    it "returns a successful response" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "assigns @books" do
      get :index
      expect(assigns(:books)).to include(book)
    end

    it "filter books by author" do
      create(:book, author: 'Author 1')
      create(:book, author: 'Author 2')

      get :index, params: { search: 'Author 1' }
      expect(assigns(:books).pluck(:author)).to eq(['Author 1'])
    end

    it "filter books by rating" do
      review = create(:review, book: book, rating: 5)

      get :index, params: { rating: 4 }
      expect(assigns(:books)).to include(book)
    end
  end

  describe "GET #show" do
    it "returns a successful response" do
      get :show, params: { id: book.id }
      expect(response).to have_http_status(:success)
    end

    it "assigns the requested book to @book" do
      get :show, params: { id: book.id }
      expect(assigns(:book)).to eq(book)
    end
  end

  describe "GET #new" do
    it "returns a successful response" do
      get :new
      expect(response).to have_http_status(:success)
    end

    it "assigns a new book to @book" do
      get :new
      expect(assigns(:book)).to be_a_new(Book)
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      let(:book_params) { attributes_for(:book) }

      it "creates a new book" do
        expect {
          post :create, params: { book: book_params }
        }.to change(Book, :count).by(1)
      end

      it "redirects to the created book" do
        post :create, params: { book: book_params }
        expect(response).to redirect_to(Book.last)
      end
    end

    context "with invalid parameters" do
      it "does not create a new book" do
        expect {
          post :create, params: { book: { name: nil } }
        }.not_to change(Book, :count)
      end

      it "renders the new template" do
        post :create, params: { book: { name: nil } }
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET #edit" do
    it "returns a successful response" do
      get :edit, params: { id: book.id }
      expect(response).to have_http_status(:success)
    end

    it "assigns the requested book to @book" do
      get :edit, params: { id: book.id }
      expect(assigns(:book)).to eq(book)
    end
  end

  describe "PATCH/PUT #update" do
    context "with valid parameters" do
      let(:new_attributes) { { name: 'Updated Book Name' } }

      it "updates the requested book" do
        patch :update, params: { id: book.id, book: new_attributes }
        book.reload
        expect(book.name).to eq('Updated Book Name')
      end

      it "redirects to the updated book" do
        patch :update, params: { id: book.id, book: new_attributes }
        expect(response).to redirect_to(book)
      end
    end

    context "with invalid parameters" do
      it "does not update the book" do
        patch :update, params: { id: book.id, book: { name: nil } }
        expect(book.name).not_to be_nil
      end

      it "renders the edit template" do
        patch :update, params: { id: book.id, book: { name: nil } }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested book" do
      book_to_destroy = create(:book)
      expect {
        delete :destroy, params: { id: book_to_destroy.id }
      }.to change(Book, :count).by(-1)
    end

    it "redirects to the books list" do
      delete :destroy, params: { id: book.id }
      expect(response).to redirect_to(books_path)
    end
  end
end