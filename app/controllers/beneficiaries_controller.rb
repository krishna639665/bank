class BeneficiariesController < ApplicationController
  include Functionality

  def new
    @account = Account.find(params[:account_id])
    unless current_user.accounts.include?(@account)
      flash[:notice] = "You are not Autherized to access!"
      render 'pages/404'
    end
  end

  def create
    sender_account = Account.find(params[:account_id])
    recipient_account = Account.find_by(account_number: params[:account_number])
    raise "Invalid account number" if recipient_account.nil?
    transaction_amount = params[:transaction_amount].to_f
    if transaction_amount <= sender_account.account_balance and recipient_account.id != sender_account.id
      recipient_account.account_balance = recipient_account.account_balance + transaction_amount
      recipient_account.save
      sender_account.account_balance = sender_account.account_balance - transaction_amount
      sender_account.save
      tnx = transaction_history(sender_account.id, recipient_account.id, transaction_amount)
      redirect_to account_transaction_path(sender_account.id, tnx)
    else
      raise "insufficient funds try less than #{sender_account.account_balance}"
    end
  rescue => exception
    flash[:alert] = exception.message
    render "new"
  end
end
