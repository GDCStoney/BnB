require_relative 'database_connection'
require 'date'
require 'twilio-ruby'

class Booking

  attr_reader :id, :listing_id, :user_id, :price_total
  attr_accessor :start_date, :end_date, :confirmation

  def initialize(id:, listing_id:, user_id:, start_date:, end_date:, price_total:, confirmation:)
    @id = id
    @listing_id = listing_id
    @user_id = user_id
    @start_date = start_date
    @end_date = end_date
    @price_total = price_total
    @confirmation = confirmation
  end

  def self.create(listing_id:, user_id:, start_date:, end_date:, price:, confirmation:)
    price_total = (Date.parse(end_date).mjd - Date.parse(start_date).mjd) * price.to_f
    p (Date.parse(end_date).mjd - Date.parse(start_date).mjd)
    p price_total
    result = DatabaseConnection.query("INSERT INTO bookings(listing_id, user_id, start_date, end_date, price_total, confirmation) VALUES(#{listing_id}, #{user_id}, '#{start_date}', '#{end_date}', #{price_total}, #{confirmation}) RETURNING id, listing_id, user_id, start_date, end_date, price_total, confirmation;")
    Booking.new(id: result[0]['id'], listing_id: result[0]['listing_id'], user_id: result[0]['user_id'], start_date: result[0]['start_date'], end_date: result[0]['end_date'], price_total: result[0]['price_total'], confirmation: result[0]['confirmation'])
  end

  def self.find(id:)
    result = DatabaseConnection.query("SELECT * FROM bookings WHERE id = #{id};")
    Booking.new(id: result[0]['id'], listing_id: result[0]['listing_id'], user_id: result[0]['user_id'], start_date: result[0]['start_date'], end_date: result[0]['end_date'], price_total: result[0]['price_total'], confirmation: result[0]['confirmation'])
  end

  def self.all
    result = DatabaseConnection.query("SELECT * FROM bookings;")
    result.map do |booking|
      Booking.new(id: booking['id'], listing_id: booking['listing_id'], user_id: booking['user_id'], start_date: booking['start_date'], end_date: booking['end_date'], price_total: booking['price_total'], confirmation: booking['confirmation'])
    end
  end

  def self.update(id:, start_date:, end_date:)
    booking = self.find(id: id)
    listing = DatabaseConnection.query("SELECT * FROM listings WHERE id = #{booking.listing_id};")
    price_total = (Date.parse(end_date).mjd - Date.parse(start_date).mjd) * listing[0]['price'].to_f
    result = DatabaseConnection.query("UPDATE bookings SET start_date = '#{start_date}', end_date = '#{end_date}', price_total = #{price_total} WHERE id = #{id} RETURNING id, listing_id, user_id, start_date, end_date, price_total, confirmation;")
    Booking.new(id: result[0]['id'], listing_id: result[0]['listing_id'], user_id: result[0]['user_id'], start_date: result[0]['start_date'], end_date: result[0]['end_date'], price_total: result[0]['price_total'], confirmation: result[0]['confirmation'])
  end

  def self.delete(id:)
    DatabaseConnection.query("DELETE FROM bookings WHERE id= #{id};")
  end

  def self.get_unavailable_dates(listing_id:)
    unavailable_dates = []
    result = DatabaseConnection.query("SELECT * FROM bookings WHERE listing_id = #{listing_id};")
    result.each do |booking|
      dates = (Date.parse(booking['start_date'])..Date.parse(booking['end_date'])).to_a
      dates.each do |date|
        unavailable_dates << date.to_s
      end
    end
    return unavailable_dates
  end

  def self.get_user_bookings(user_id:)
    result = DatabaseConnection.query("SELECT * FROM bookings WHERE user_id = #{user_id};")
    result.map do |booking|
      Booking.new(id: booking['id'], listing_id: booking['listing_id'], user_id: booking['user_id'], start_date: booking['start_date'], end_date: booking['end_date'], price_total: booking['price_total'], confirmation: booking['confirmation'])
    end
  end

  def self.text_confirmation(username:, listing_name:, start_date:, end_date:, price_total:)
    account_sid = 'AC35d0264a3e87b14a0291d2db95328967'
    auth_token = '146eb474ec7753f38a17e1333b9aa032'
    @client = Twilio::REST::Client.new(account_sid, auth_token)

    from = '+13345084297' # Your Twilio number
    to = ENV['PHONE_NO'] # Your mobile phone number

    message = @client.messages.create(
      body: "Hi #{username}! You have made a booking at #{listing_name}. Your stay is from: #{start_date} to #{end_date}. The total price is: £#{price_total} Enjoy your stay BEACH!",
      from: from,
      to: to)
    p message.sid
  end

end
