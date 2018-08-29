class User < ApplicationRecord
  has_many(:addresses, class_name: 'Ecomm::Address',
                       foreign_key: :customer_id, dependent: :destroy)
  has_one(:billing_address, -> { billing }, class_name: 'Ecomm::Address',
                                            foreign_key: :customer_id)
  has_many(:orders, class_name: 'Ecomm::Order', foreign_key: :customer_id,
                    dependent: :destroy)
  has_many(:reviews, dependent: :destroy)

  after_create(:send_welcome_user)

  devise(:database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:facebook])

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.addresses << Ecomm::Address.new(
        first_name: auth.info.first_name,
        last_name: auth.info.last_name,
        city: auth.info.hometown,
        address_type: 'billing'
      )
      user.password = Devise.friendly_token[0, 20]
    end
  end

  private

  def send_welcome_user
    UserMailer.user_email(self).deliver
  rescue StandardError => error
    Rails.logger.error(error.inspect)
  end
end
