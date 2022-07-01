class User < ApplicationRecord
  attr_writer :login
  has_many :accounts, dependent: :destroy
  after_create :assign_default_role
  rolify

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable,
         :omniauthable, omniauth_providers: [:facebook, :google_oauth2],
                        authentication_keys: [:login]

  VALID_USERNAME_REGEX = /\A(?=.{8,20}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])/i
  VALID_PASSWORD = /(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}/
  validates :username, presence: true, uniqueness: { case_sensitive: false }
  #  format: { with: VALID_USERNAME_REGEX, message: 'cannot have special characters'  }

  # validates :password, presence: true, format: {with: VALID_PASSWORD, message: 'week password'}

  def login
    @login || self.username || self.email
  end

  def assign_default_role
    self.add_role(:user) if self.roles.blank?
  end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if (login = conditions.delete(:login))
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      if conditions[:username].nil?
        where(conditions).first
      else
        where(username: conditions[:username]).first
      end
    end
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.username = auth.info.name   # assuming the user model has a name
    end
  end
  
end
