class Card < ApplicationRecord
  has_one :account
  has_many :transactions, :through => :account

  validates :number, presence: true
  validates :cvv, presence: true
end
