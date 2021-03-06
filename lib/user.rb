require 'bcrypt'
require_relative 'database_connection'

class User
  attr_reader :id, :username, :phone_no, :email
  @current_user

  def initialize(id, username, phone_no, email)
    @id = id
    @username = username
    @phone_no = phone_no
    @email = email
  end

  def self.sign_up(username:, password:, phone_no:, email:)
    return false if !self.check_username_taken(username: username)
    encrypted_password = BCrypt::Password.create(password)
    DatabaseConnection.query("INSERT INTO users (username, password, email, phone_no) VALUES ('#{username}', '#{encrypted_password}', '#{email}', '#{phone_no}');")
    result = DatabaseConnection.query("SELECT * FROM users WHERE username = '#{username}';")
    User.new(result[0]['id'], result[0]['username'], result[0]['phone_no'], result[0]['email'])
  end

  def self.sign_in(username:, password:)
    return nil if self.check_username_taken(username: username)
    result = DatabaseConnection.query("SELECT * FROM users WHERE username = '#{username}';")
    if BCrypt::Password.new(result[0]['password']) == password
      ENV['PHONE_NO'] = "+44" + result[0]['phone_no']
      return User.new(result[0]['id'], result[0]['username'], result[0]['phone_no'], result[0]['email'])
    else
      nil
    end
  end

  # return a list of all user objects
  def self.all
    result = DatabaseConnection.query("SELECT * FROM users;")
    result.map do |user|
      User.new(user['id'], user['username'], user['phone_no'], user['email'])
    end
  end

  # returns user object with details from given ID
  def self.find(id:)
    result = DatabaseConnection.query("SELECT * FROM users WHERE id = #{id};")
    User.new(result[0]['id'], result[0]['username'], result[0]['phone_no'], result[0]['email'])
  end

  private
  # returns false if username exists and true if not
  def self.check_username_taken(username:)
    result = self.all
    result.each do |user|
      return false if user.username == username
    end
    true
  end

end
