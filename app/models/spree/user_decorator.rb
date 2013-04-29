Spree.user_class.class_eval do
  has_many :user_authentications, :dependent => :destroy

  devise :omniauthable

  def apply_omniauth(omniauth)
    if omniauth['provider'] == "facebook"
      self.email = omniauth['info']['email'] if email.blank?
      self.username = omniauth['extra']['raw_info']['username'] if username.blank?
      self.firstname = omniauth['info']['first_name'] if firstname.blank?
      self.lastname = omniauth['info']['last_name'] if lastname.blank?
      self.gender = omniauth['extra']['raw_info']['gender'] if gender.blank?
    end
    user_authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
  end

  def password_required?
    (user_authentications.empty? || !password.blank?) && super
  end
end
