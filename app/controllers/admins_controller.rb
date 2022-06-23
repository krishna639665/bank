class AdminsController < ApplicationController

  def index
    @users = User.count
    @accounts = Account.count
    @transactions = Transaction.count
    @cards = Card.count
  end

  def users
    @users = User.all
  end

  def accounts
    @accounts = Account.all  
  end

  def transactions
    @transactions = Transaction.all
  end

  def cards
    @cards = Card.all
  end

end
