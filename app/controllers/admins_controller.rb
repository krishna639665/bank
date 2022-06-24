class AdminsController < ApplicationController
  def index
    @users = User.count
    @accounts = Account.count
    @transactions = Transaction.count
    @cards = Card.count
  end

  def users
    @pagy, @users = pagy(User.all,items:6)
  end

  def accounts
    @pagy, @accounts = pagy(Account.all,items:6)
  end

  def transactions
    @pagy, @transactions = pagy(Transaction.all,items:10)
  end

  def cards
    @pagy, @cards = pagy(Card.all,items:6)
  end
end
