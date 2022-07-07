class DepositsController < ApplicationController
  include Functionality

  def new
    @account = Account.find(params[:account_id])
    unless current_user.accounts.include?(@account)
      flash[:notice] = "You are not Autherized to access!"
      render "pages/404"
    end
  end

  def create
    sender_account = Account.find(1)
    recipient_account = Account.find(params[:account_id])
    raise "Invalid amount" if params[:transaction_amount].to_i < 0
    raise "Invalid amount" unless params[:transaction_amount] =~ /\A[±]?\d+\z/
    raise "Account number doesnt match" unless params[:account_number] == recipient_account.account_number
    transaction_amount = params[:transaction_amount].to_f
    if transaction_amount <= sender_account.account_balance and recipient_account.id != sender_account.id
      msg = "You Debit with Account No. #{recipient_account.account_number} amount RS. #{transaction_amount} on."
      withrawal_amount(sender_account.id, transaction_amount, msg)
      msg = "Your Account No. #{"xxxxxxxx" + recipient_account.account_number.split(//).last(4).join} Credited with amount RS. #{transaction_amount} on."
      deposit_amount(recipient_account.id, transaction_amount, msg)
      tnx = transaction_history(sender_account.id, recipient_account.id, transaction_amount)
      redirect_to account_transaction_path(recipient_account.id, tnx)
    else
      raise "Invalid Amount"
    end
  rescue => exception
    flash[:alert] = exception.message
    redirect_to new_account_deposit_path
  end

  def account_validation(account_num)
    Functionality.transaction do
      if Account.find_by(account_number: account_num) == nil
        binding.break
        flash[:alert] = "Invalid account number provided"
      end
    end
  end
end
