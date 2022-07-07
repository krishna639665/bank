class CardChargeJob
  include Sidekiq::Job
  include Functionality

  def perform(account_id)
    charge(account_id)
  end
  def charge(account_id)
    admin_ac_id = 1
    amount = 199.0
    withrawal_amount(account_id, amount)
    deposit_amount(admin_ac_id, amount)
    transaction_history(account_id, admin_ac_id, amount)
  end
end
