class CardTransfersController < ApplicationController
  include Functionality

  def new
    @account = Account.find(params[:account_id])
    unless current_user.accounts.include?(@account)
      flash[:notice] = "You are not Autherized to access!"
      render 'pages/404'
    end
  end

  def create
    raise "Invalid Card Number Provided" unless card_check(card_params[:number])
    raise "Wrong Pin Entered" unless valid_card_transfers(card_params[:account_id], card_params[:pin])
    raise "Invalid amount" unless card_params[:transaction_amount] =~ /\A[±]?\d+\z/
    raise "Amount should be greater_than 0" if card_params[:amount].to_i < 0
    sender_account = Account.find(card_params[:account_id])
    recipient_account = Account.find(Card.find_by(number: card_params[:number]).account_id)
    raise "Invalid account number" if recipient_account.nil?
    transaction_amount = card_params[:transaction_amount].to_f
    if transaction_amount <= sender_account.account_balance and recipient_account.id != sender_account.id
      withrawal_amount(sender_account.id, transaction_amount)
      deposit_amount(recipient_account.id,transaction_amount)
      tnx = transaction_history(sender_account.id, recipient_account.id, transaction_amount)
      redirect_to account_transaction_path(sender_account.id, tnx)
    else
      raise "insufficient funds try less than #{sender_account.account_balance}"
    end
  rescue => exception
    flash[:alert] = exception.message
    redirect_to new_account_card_transfer_path
  end

  private

  def card_params
    params.permit(:number, :transaction_amount, :account_id, :pin)
  end
end
