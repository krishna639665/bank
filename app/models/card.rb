class Card < ApplicationRecord
  include Vault::EncryptedModel
  vault_attribute :number
  vault_attribute :cvv
  vault_attribute :pin
  belongs_to :account
  has_many :transactions, :through => :account

  validates :number, presence: true
  validates :cvv, presence: true
end
