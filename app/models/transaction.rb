class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :book
  validates :credit_card_number, presence: true
  validates :address, presence: true
  validates :phone_number, presence: true
  validates :quantity, numericality: { greater_than_or_equal_to:0 }
end
