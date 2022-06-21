class Account < ApplicationRecord
    belongs_to :user
    has_many :transactions
    belongs_to :card

    validates :first_name, presence: true, length: { minimum: 2, maximum:15, message: 'minimum 2 ' }
    validates :nomine_name, presence: true
    validates :age, presence:true, numericality: { greater_than: 9 }
    validates :phone_number, presence: true, numericality: true,
                    length: { is: 10 ,message: 'only 10 number'},
                    format: { with: /\b^([6789][0-9]{9})$\b/, message: "wrong number" }
    validates :adhar_number, presence: true, numericality: true,
                    length: { is:12, message: 'wrong number' } 
    validates :address, presence: true
    validates :gender, presence: true

end
