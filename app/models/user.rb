class User < ActiveRecord::Base
  include TokenAuthenticatable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable,
         :trackable, :validatable,
         :token_authenticatable
  has_many :orders
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  after_create :ensure_authentication_token

  scope :clients, -> { where.not(is_admin: true) }
  scope :admins, -> { where(is_admin: true) }

  def admin?
    self.is_admin
  end
end
