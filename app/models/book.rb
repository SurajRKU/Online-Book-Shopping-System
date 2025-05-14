class Book < ApplicationRecord
  has_many :transactions, dependent: :destroy
  has_many :reviews, dependent: :destroy
  validates :name, presence: true
  validates :isbn, presence: true
  validates :author, presence: true
  validates :stock, numericality: { greater_than_or_equal_to:0 }
end
