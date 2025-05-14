require 'rails_helper'

describe Book, type: :model do

  describe 'book validations' do
    it 'is not valid without a name' do
      book = Book.new(name: nil)
      expect(book).to_not be_valid
    end

    it 'is not valid without an author' do
      book = Book.new(author: nil)
      expect(book).to_not be_valid
    end

    it 'is not valid without a price' do
      book = Book.new(price: nil)
      expect(book).to_not be_valid
    end

    it 'is not valid without stock' do
      book = Book.new(stock: nil)
      expect(book).to_not be_valid
    end

    it 'is not valid without an ISBN' do
      book = Book.new(isbn: nil)
      expect(book).to_not be_valid
    end
  end

  describe '#average_rating' do
    let(:book) { create(:book) }
    let(:user) { create(:user) }

    context 'when there are reviews' do
      before do
        create(:review, rating: 4, book: book, user: user)
        create(:review, rating: 5, book: book, user: user)
      end

      it 'returns the correct average rating' do
        expect(book.average_rating).to eq(4.5)
      end
    end
  end
end