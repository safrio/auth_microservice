class UserSession < Sequel::Model
  many_to_one :user

  def before_save
    self.uuid = SecureRandom.uuid
  end
end
