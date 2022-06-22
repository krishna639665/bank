module Functionality
    extend ActiveSupport::Concern

    def withrawal_amount(account_id, amount)
        account =Account.find(account_id).amount -= amount
        account.save
    end

    def deposit_amount(account_number,amount)
        account = Account.find_by(account_number: account_number).amount += amount
        account.save
    end

    def transaction_history(sender,recipient,amount)
        transaction_id=("%06d" % rand(0..999999)).to_s
        sender_account = Account.find(sender)
        recipient_account = Account.find(recipient)
        debit_details = {transaction_id: transaction_id, transaction_type:"debited",transaction_status: "completed", transaction_amount: amount}
        tnx = sender_account.transactions.create(debit_details)
        cred_details = {transaction_id: transaction_id, transaction_type:"credited",transaction_status: "completed", transaction_amount: amount}
        recipient_account.transactions.create(cred_details)
        return tnx
    end
end