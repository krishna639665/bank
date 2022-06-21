class Transaction < ApplicationRecord
  belongs_to :account
  validates :transaction_amount, :numericality => { greater_than: 0 } ,presence: true
  
  class << self
    def transfer_funds(account_params)
      @@account_number =account_params[:account_number]
    end
  end


  def perform_deposit
    @sender_account.account_balance = sender_account.account_balance + deposit_amount
  end

  def account_number_check?
    account_number = @@account_number
    if Account.find_by(account_number: account_number) == nil
      errors.add(:transaction_amount, 'Invalid Account Number')
      return false 
    end
  end
    
end
