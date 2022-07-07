class AdminsController < ApplicationController
  before_action :authenticate_user!
  include Functionality
  def index
    @users = User.count
    @accounts = Account.count
    @transactions = Transaction.count
    @cards = Card.count
  end

  def users
    @pagy, @users = pagy(User.order(id: :asc), items: 6)
  end

  def accounts
    @pagy, @accounts = pagy(Account.order(id: :asc), items: 6)
  end

  def transactions
    @pagy, @transactions = pagy(Transaction.order(created_at: :desc), items: 10)
  end

  def cards
    @pagy, @cards = pagy(Card.order(id: :asc), items: 6)
  end

  def show
    @user = User.find(params[:id])
  end

  def activation
    @pagy, @accounts =  pagy(Account.where(status: false), items: 6)
  end

  def active
    account = Account.find(params[:id])
    account.status = true
    account.save
    redirect_to admin_activations_path
  end

  def reverse_tnx
    tnxs = Transaction.where(transaction_id: params[:format])
    tnxs.each do |tnx| 
      msg1 = "Dear customer as per your request RS. #{tnx.transaction_amount} revise back to Your Account #{"xxxxxxxx" + Account.find(tnx.account_id).account_number.split(//).last(4).join} on." if tnx.transaction_type == "debited"
      msg2 = "Dear customer Your Account #{"xxxxxxxx" + Account.find(tnx.account_id).account_number.split(//).last(4).join} Debit with amount RS. #{tnx.transaction_amount} due to TNX ID #{tnx.transaction_id} is revised on." if tnx.transaction_type == "credited"
      deposit_amount(tnx.account_id,tnx.transaction_amount, msg1) if tnx.transaction_type == "debited"
      withrawal_amount(tnx.account_id,tnx.transaction_amount, msg2) if tnx.transaction_type == "credited"
      tnx.revert = true
      tnx.save
    end
    redirect_to admin_transactions_path
    flash[:notice] = "Transaction Revised From Bank End"
  end
end
