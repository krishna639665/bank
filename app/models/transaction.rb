class Transaction < ApplicationRecord
    belongs_to :account
    validates :transaction_amount, presence: true

end
