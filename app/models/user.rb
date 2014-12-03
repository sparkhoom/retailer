class User < ActiveRecord::Base
  has_secure_password
  before_create { generate_token(:token)}
  before_create { generate_name(:name)}

  validates :email, :presence => true, :uniqueness => {:case_sensitive => false}, :email_format => true
  validates :password, :length => { :minimum => 6 }, :on => :create
  validates :phone_number, :presence => true, :phone_number_format => true

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  def generate_name(column)
      self[column] = "user" + self[:token]
  end
  
end
