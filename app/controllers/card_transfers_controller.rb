class CardTransfersController < ApplicationController
    include Functionality

    def new
    end

    def create
        raise "Invalid Card Number Provided" unless card_check(card_params[:number])
        raise "Wrong Pin Entered" unless valid_card_transfers(card_params[:account_id], card_params[:pin])
        raise "Invalid amount" unless card_params[:transaction_amount].to_i =~ /[0-9]{6,6}/ 
        raise "Amount should be greater_than 0" unless card_params[:amount].to_i < 0
        sender_account = Account.find(card_params[:account_id])
        recipient_account = Account.find(Card.find_by(number: card_params[:number]).account_id)
        raise "Invalid account number" if recipient_account.nil?
        transaction_amount = card_params[:transaction_amount].to_f
        if transaction_amount <= sender_account.account_balance and recipient_account.id != sender_account.id  
            binding.break
            recipient_account.account_balance = recipient_account.account_balance + transaction_amount
            binding.break
            recipient_account.save
            sender_account.account_balance = sender_account.account_balance - transaction_amount
            binding.break
            sender_account.save
            tnx = transaction_history(sender_account.id,recipient_account.id,transaction_amount)
            redirect_to account_transaction_path(sender_account.id,tnx)
        else
            raise "insufficient funds try less than #{sender_account.account_balance}"
        end
        rescue => exception
            flash[:alert] = exception.message
            render 'new'
    end

    private

    def card_params
        params.permit(:number, :transaction_amount, :account_id, :pin)
    
    end
end
