class TransactionsController < ApplicationController
  def index
    @pagy, @tnxs = pagy(Account.find(params[:account_id]).transactions, items: 10)
  end

  def show
    @tnx = Transaction.find(params[:id])
  end
end
