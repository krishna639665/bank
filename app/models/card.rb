class Card < ApplicationRecord
  belongs_to :account
  has_many :transactions, :through => :account

  validates :number, presence: true
  validates :cvv, presence: true
end
