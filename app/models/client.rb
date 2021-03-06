class Client < ApplicationRecord
  before_save { self.email = email.downcase if email.present? }

  validates :name, presence: true, length: { maximum: 30 }
  validates :phone_1, format: { with: VALID_PHONE_REGEX }, allow_blank: true
  validates :phone_2, format: { with: VALID_PHONE_REGEX }, allow_blank: true
  validates :fax, format: { with: VALID_FAX_REGEX }, allow_blank: true
  validates :email, length: { maximum: 254 }, format: { with: VALID_EMAIL_REGEX }, allow_blank: true
  validates :login_id, presence: true, length: { in: 8..12 }, uniqueness: true
  validate :client_login_id_is_correct?
  
  has_many :matters, dependent: :destroy
  has_many :quotations, dependent: :destroy
  
  enum gender: {male: 0, female: 1}

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :rememberable, :validatable, authentication_keys: [:login_id]
         
  # 顧客IDは「CL-」から始めさせる
  def client_login_id_is_correct?
    errors.add(:login_id, "は「CL-」から始めてください") if login_id.present? && !login_id.start_with?("CL-")
  end

  # 登録時にemailを不要にする
  def email_required?
    false
  end

  def will_save_change_to_email?
    false
  end

  # ログインID変更時のreset_password_token不要にする
  def will_save_change_to_login_id?
    false
  end
end
