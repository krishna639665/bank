class CardChargeJob
  include Sidekiq::Job
  include Functionality

  def perform(account_id)
    charge(account_id)
  end

  def charge(account_id, card)
    account = Account.find(account_id)
    card = account.card
    admin_ac_id = 1
    amount = 15.0
    msg = "Dear Customer, Your A/C ending with #{"xxxxxxxx" + account.number.split(//).last(4).join} has been is debited with an #{amount} towards monthly maintance charge for your Swiss Card ending with #{"xxxx-xxxx-xxxx-" + card.number.split(//).last(4).join} on."
    withrawal_amount(account_id, amount, msg)
    msg = "Your account receive card charge Ending with #{"xxxx-xxxx-xxxx-" + card.number.split(//).last(4).join} is credited with an #{amount} on."
    deposit_amount(admin_ac_id, amount, msg)
    transaction_history(account_id, admin_ac_id, amount)
  end
end
