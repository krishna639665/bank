class AccountsController < ApplicationController
  before_action :show_params, only: [:show, :edit, :update]

  def index
    @accounts = current_user.accounts
  end

  def new
    if current_user.accounts.count == 4
      flash[:alert] = "You have created the maximum number of accounts!"
      redirect_to accounts_path
    end
    @account = Account.new
  end

  def show
    unless (current_user.accounts.include?(@account)) &&  (@account.status == true)
      flash[:notice] = "You are not Autherized to access!"
      render "pages/404"
    end
  end

  def edit
    unless (User.first == current_user || current_user.accounts.include?(@account))
      flash[:notice] = "You are not Autherized to access!"
      render "pages/404"
    end
  end

  def create
    new_params = account_params.merge!(auto_generate)
    @account = current_user.accounts.create(new_params)
    if @account.errors.empty?
      flash[:notice] = "Successfully created account. Waiting for Approval from bank side "
      redirect_to accounts_path
    else
      render "new"
    end
  end

  def update
    if @account.update(account_params)
      flash[:notice] = "Account updated successfully"
      redirect_to @account
    else
      render "edit"
    end
  end

  private

  def show_params
    if !(Account.exists?(params[:id]))
      flash[:notice] = "You are not Autherized to access!"
      render "pages/404"
    else
      @account = Account.find(params[:id])
    end
  end

  def account_params
    params.require(:account).permit(:first_name, :last_name, :nomine_name, :phone_number, :age, :adhar_number, :address, :gender, :account_type)
  end

  def auto_generate
    account_number = ("%012d" % rand(0..999999999999)).to_s
    account_ifsc = "SWISS0001102"
    account_balance = 0.0
    return acc_hash = { "account_number" => account_number, "account_ifsc" => account_ifsc, "account_balance" => account_balance }
  end
end
