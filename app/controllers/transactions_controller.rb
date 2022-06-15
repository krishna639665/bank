class TransactionsController < ApplicationController

    after_action :credit_transaction, only: [:create]

    def show

    end

    def new
        @tnx = Transaction.new
    end

    def create
        Transaction.transaction do
            @transaction_id=("%06d" % rand(0..999999)).to_s
            current_account = current_user.accounts.find(params[:account_id])
            new_params = transaction_params.merge!(auto_generate)
            @tnx = current_account.transactions.create(new_params)
        end
    end

    private

    def transaction_params
        params.require(:transaction).permit(:transaction_amount,:transaction_type,:account_id)
    end

    def account_params
        params.require(:transaction).permit(:account_number,:account_ifsc)
    end

    def auto_generate
        transaction_status = "completed"
        return tnx_hash = {transaction_id: @transaction_id, transaction_status: transaction_status}
    end

    def credit_transaction
        credit_account = Account.find_by(account_number: account_params[:account_number])
        new_params = transaction_params.merge!(auto_generate)
        new_params[:transaction_type] = "credited"
        Transaction.transaction do
            tnx = credit_account.transactions.create(new_params)
        end
        
    end


    def perform_transfer(recipient, credit_amount, sender)

    end

end
