require 'booking'
require 'database_connection'
require 'db_helpers.rb'

RSpec.describe Booking do
  before(:each) do
    create_user
    create_listing
    create_second_user
  end

  describe '.all' do
    it "Returns a list of all booking" do
      create_booking
      expect(Booking.all.length).to eq 1
      expect(Booking.all[0].user_id).to eq "2"
    end
  end

  describe '.create' do
    it "Inserts a new booking into db and returns booking object" do
      expect(Booking.create(listing_id: 1, user_id: 1, start_date: '2020-12-25', end_date: '2020-12-28', price: 40.00, confirmation: false)).to be_an_instance_of(Booking)
    end
  end

  describe '.find' do
    it 'Returns a booking object with details of given ID' do
      booking = Booking.create(listing_id: 1, user_id: 1, start_date: '2020-12-25', end_date: '2020-12-28', price: 40.00, confirmation: false)
      expect(Booking.find(id: booking.id).user_id).to eq "1"
    end
  end
end
