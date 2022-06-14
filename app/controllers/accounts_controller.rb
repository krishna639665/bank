class AccountsController < ApplicationController


    def new
        @account = Account.new
    end


    def create
        new_params = account_params.merge!(auto_generate)
        @account= current_user.accounts.create(new_params)
        if @account.errors.empty?
            flash[:notice] ="Successfully created account"
            redirect_to account_path(@account)
        else
            render 'new'
        end
    end

    def show
        @account =Account.find(params[:id])
    end

    def edit
        @account = Account.find(params[:id])
    end

    def update
        @account = Account.find(params[:id])
        if @account.update(account_params)
            flash[:notice] = "Account updated successfully"
            redirect_to @account
        else
            render 'edit'
        end
    end

    private

    def account_params
        params.require(:account).permit(:first_name, :last_name,:nomine_name,:phone_number,:age,:adhar_number,:address,:gender,:account_type)
    end

    def auto_generate
        account_number=rand.to_s[2..11].to_i
        account_ifsc = ifsc = "SWISS0001102"
        account_balance = 0.0
        return acc_hash = {"account_number"=>account_number,"account_ifsc" =>account_ifsc,"account_balance" =>account_balance}

    end




end
