class Transaction < ApplicationRecord
  belongs_to :account
  validates :transaction_amount, :numericality => { greater_than: 0 } ,presence: true
    
end
