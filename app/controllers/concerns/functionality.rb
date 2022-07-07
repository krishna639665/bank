module Functionality
  extend ActiveSupport::Concern

  def withrawal_amount(account_id, amount, msg)
    account = Account.find(account_id)
    account.account_balance -= amount
    account.save
    notify(account_id, amount, msg)
  end

  def deposit_amount(account_id, amount,msg)
    account = Account.find(account_id)
    account.account_balance += amount
    account.save
    notify(account_id, amount, msg)
  end

  def transaction_history(sender, recipient, amount)
    transaction_id = ("%06d" % rand(0..999999)).to_s
    sender_account = Account.find(sender)
    recipient_account = Account.find(recipient)
    debit_details = { transaction_id: transaction_id, transaction_type: "debited", transaction_status: "completed", transaction_amount: amount }
    tnx = sender_account.transactions.create(debit_details)
    cred_details = { transaction_id: transaction_id, transaction_type: "credited", transaction_status: "completed", transaction_amount: amount }
    recipient_account.transactions.create(cred_details)
    return tnx
  end

  def valid_card_transfers(account_id, pin)
    account = Account.find(account_id)
    return true if account.card.pin == pin
  end

  def card_check(card_number)
    return true if Card.find_by(number: card_number) != nil
  end

  def notify(account_id, amount, msg)
    user = Account.find(account_id).user_id
    Notification.create(user_id: user, message: msg)
  end
end
