class User < Sequel::Model
  require 'bcrypt'

  include BCrypt

  NAME_FORMAT = %r{\A\w+\z}

  one_to_many :sessions, class: :UserSession

  def validate
    super
    validates_presence :name, message: I18n.t(:blank, scope: 'model.errors.user.name')
    validates_presence :email, message: I18n.t(:blank, scope: 'model.errors.user.email')
    validates_presence :password, message: I18n.t(:blank, scope: 'model.errors.user.password')
    validates_format NAME_FORMAT, :name, message: I18n.t(:format, scope: 'model.errors.user.name')
  end

  def password
    @password ||= Password.new(password_digest)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_digest = @password
  end

  def authenticate(password)
    BCrypt::Password.new(password_digest) == password
  end
end
