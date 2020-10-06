class Staff < ApplicationRecord
  validates :name, presence: true, length: { maximum: 30 }
  validates :employee_id, presence: true, length: { in: 8..10 }
  validates :email, length: { maximum: 254 }
  validate :staff_employee_id_is_correct?

  has_many :matter_staffs, dependent: :destroy
  has_many :matters, through: :matter_staffs
  has_many :staff_events, dependent: :destroy
  has_many :staff_event_titles, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, authentication_keys: [:employee_id]

  # スタッフの従業員IDは「ST-」から始めさせる
  def staff_employee_id_is_correct?
    errors.add(:employee_id, "は「ST-」から始めてください。") if employee_id.present? && employee_id[0..2] != "ST-"
  end

  # emailでなくemployee_idを認証キーにする
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if employee_id = conditions.delete(:employee_id)
      where(conditions).where(employee_id: employee_id).first
    else
      where(conditions).first
    end
  end

  # 退社日は入社日がないとNG
  def joined_with_resigned
    errors.add(:joined_on, "を入力してください。") if !self.joined_on.present? && self.resigned_on.present?
  end

  # 退社日は入社日以降
  def resigned_is_since_joined
    if self.joined_on.present? && self.resigned_on.present? && self.joined_on > self.resigned_on
      errors.add(:resigned_on, "は入社日以降にしてください。")
    end
  end

  # 登録時にemailを不要にする
  def email_required?
    false
  end

  def will_save_change_to_email?
    false
  end
end
