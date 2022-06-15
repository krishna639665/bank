class Account < ApplicationRecord

    belongs_to :user
    has_many :transactions

    validates :first_name, presence: true, length: { minimum: 2, maximum:15 }
    validates :last_name, length: { minimum: 2 }
    validates :age, numericality: { message: "%{value} seems wrong" }
    validates :nomine_name, presence: true
    validates :phone_number, presence: true
    validates :address, presence: true
    validates :adhar_number, presence: true
    validates :gender, presence: true

end
