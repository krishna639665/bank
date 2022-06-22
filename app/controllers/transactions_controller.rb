class TransactionsController < ApplicationController
    def index
        @tnxs= Account.find(params[:account_id]).transactions
    end

    def show
        @tnx = Transaction.find(params[:id])
    end

end