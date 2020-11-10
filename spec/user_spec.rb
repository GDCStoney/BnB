require 'user'

RSpec.describe User do

  describe '.member?' do
    it 'Returns false if user is not logged in' do
      expect(User.member?).to eq false
    end

    it 'Returns true if user is logged in' do
      User.sign_up(username: "Test", password: "Test", phone_no: "test", email: "test@test.com")
      expect(User.member?).to eq true
    end
  end

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
      expect(User.sign_in(username: "Test", password: "Test")).to eq true
    end

    it 'Returns false if user password is incorrect' do
      User.sign_up(username: "Test", password: "Test", phone_no: "test", email: "test@test.com")
      expect(User.sign_in(username: "Test", password: "test1")).to eq false
    end

    it 'Returns false if username does not exist' do
      User.sign_up(username: "Test", password: "Test", phone_no: "test", email: "test@test.com")
      expect(User.sign_in(username: "test123", password: "test")).to eq false
    end
  end

  describe '.find' do
    it 'Returns a user object with details of given ID' do
      User.sign_up(username: "Test", password: "Test", phone_no: "test", email: "test@test.com")
      expect(User.find(id: User.current_user).username).to eq "Test"
    end
  end
end