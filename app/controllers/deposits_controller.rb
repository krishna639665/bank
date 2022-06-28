class DepositsController < ApplicationController
    include Functionality
    def new
        @account = Account.find(params[:account_id])
        unless current_user.accounts.include?(@account)
            flash[:notice] = "You are not Autherized to access!"
            render 'pages/404'
        end
    end

    def create
        # We have to give admin account id below. currently i given 5 as admin account
        if Account.find_by(account_number: params[:account_number]) == nil
            flash[:alert]= "Invalid account number provided"
            raise "Invalid account number provided"
        end
        sender_account = Account.find(5)
        recipient_account = Account.find(params[:account_id])
        raise "Invalid amount" if params[:transaction_amount].to_i < 0
        raise "Invalid amount" unless params[:transaction_amount] =~ /\A[±]?\d+\z/
        raise "Account number doesnt match" unless params[:account_number] == recipient_account.account_number
        transaction_amount = params[:transaction_amount].to_f
        if transaction_amount <= sender_account.account_balance and recipient_account.id != sender_account.id  
            # recipient_account.account_balance = recipient_account.account_balance + transaction_amount
            # recipient_account.save
            # sender_account.account_balance = sender_account.account_balance - transaction_amount
            # sender_account.save
            withrawal_amount(sender_account.id, transaction_amount)
            deposit_amount(recipient_account.id,transaction_amount)
            tnx = transaction_history(sender_account.id,recipient_account.id,transaction_amount)
            redirect_to account_transaction_path(recipient_account.id,tnx)
        else
            raise "Invalid Amount"
        end
        rescue => exception
            flash[:alert] = exception.message
            render 'new'
    end

    def account_validation(account_num)
        Functionality.transaction do
            if Account.find_by(account_number: account_num) == nil
                binding.break
                flash[:alert]= "Invalid account number provided"
            end
        end
    end

   
end
