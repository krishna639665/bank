class Transaction < ApplicationRecord
  belongs_to :account
  validates :transaction_amount, :numericality => { :greater_than_or_equal_to => 0 } ,presence: true
  after_create :perform_transfer
  # validate :check_balance!

  class << self
    def transfer_funds(account_params)
      @@account_number =account_params[:account_number]
    end
  end

  def perform_transfer
    account_number = @@account_number
    sender_account = Account.find(account_id)
    recipient_account = Account.find_by(account_number:account_number)
    if recipient_account.user_id == sender_account.user_id
      flash[:notice] = "Unauthorized Transaction"
      redirect_to new_account_transaction_path(@sender_account)
    else
      perform_transfer.transaction do
        recipient_account.account_balance = recipient_account.account_balance + params[:transaction][:transaction_amount]
        recipient_account.save
        sender_account.account_balance = sender_account.account_balance - params[:transaction][:transaction_amount]
        sender_account.save
      end
    end

  end


  #def check_balance!
  #     errors.add(:account_balance, 'Insufficient funds') if account.account_balance < transaction_amount
  # end
    
end
