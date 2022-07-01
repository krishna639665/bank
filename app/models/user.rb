class User < ApplicationRecord
  attr_writer :login
  has_many :accounts, dependent: :destroy
  after_create :assign_default_role
  rolify

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :two_factor_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable,
         :omniauthable, omniauth_providers: [:facebook, :google_oauth2],
                        :otp_secret_encryption_key => ENV["OTP_SECRET_KEY"],
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

  def generate_two_factor_secret_if_missing!
    return unless otp_secret.nil?
    update!(otp_secret: User.generate_otp_secret)
  end

  def enable_two_factor!
    current_user.otp_required_for_login = true
    current_user.otp_secret = User.generate_otp_secret
    current_user.save!
  end

  def disable_two_factor!
    update!(
      otp_required_for_login: false,
      otp_secret: nil,
      otp_backup_codes: nil,
    )
  end

  def two_factor_qr_code_uri
    issuer = ENV["OTP_2FA_ISSUER_NAME"]
    label = [issuer, email].join(":")

    otp_provisioning_uri(label, issuer: issuer)
  end
end
