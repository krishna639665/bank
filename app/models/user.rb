class User < ApplicationRecord
  after_create :assign_default_role
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def assign_default_role
    self.add_role(:user) if self.roles.blank?
  end

  def testing_role

  end
end
