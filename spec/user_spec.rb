require 'user'
require 'database_connection'

RSpec.describe User do

  describe '.all' do
    it "Returns a list of all users" do
      User.sign_up(username: "Test", password: "Test", phone_no: "test", email: "test@test.com")
      expect(User.all.length).to eq 1
      expect(User.all[0].username).to eq "Test"
    end
  end

  describe '.sign_in' do
    it 'Returns true of user password is correct' do
      User.sign_up(username: "Test", password: "Test", phone_no: "test", email: "test@test.com")
      result = DatabaseConnection.query("SELECT id FROM users WHERE username = 'Test';")
      expect(User.sign_in(username: "Test", password: "Test")).to eq result[0]['id']
    end

    it 'Returns nil if user password is incorrect' do
      User.sign_up(username: "Test", password: "Test", phone_no: "test", email: "test@test.com")
      expect(User.sign_in(username: "Test", password: "test1")).to eq nil
    end

    it 'Returns nil if username does not exist' do
      User.sign_up(username: "Test", password: "Test", phone_no: "test", email: "test@test.com")
      expect(User.sign_in(username: "test123", password: "test")).to eq nil
    end
  end

  describe '.find' do
    it 'Returns a user object with details of given ID' do
      User.sign_up(username: "Test", password: "Test", phone_no: "test", email: "test@test.com")
      result = DatabaseConnection.query("SELECT id FROM users WHERE username = 'Test';")
      expect(User.find(id: result[0]['id']).username).to eq "Test"
    end
  end
end