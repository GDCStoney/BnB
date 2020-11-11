require_relative 'database_connection'
require 'date'

class Listing

  attr_accessor :name, :price, :description, :available_dates
  attr_reader :id, :host_id

  def initialize(id:, name:, price:, description:, host_id:, start_date:, end_date:)
    @id = id
    @name = name
    @price = price
    @description = description
    @host_id = host_id
    @available_dates = [Date.parse(start_date), Date.parse(end_date)]
  end

  def self.create(name:, price:, description:, host_id:, start_date:, end_date:)
    result = DatabaseConnection.query("INSERT INTO listings(name, price, description,
      host_id, start_date, end_date) VALUES('#{name}', #{price}, '#{description}', #{host_id}, '#{start_date}', '#{end_date}') RETURNING id, name, price, description, host_id, start_date, end_date;")
    Listing.new(id: result[0]['id'], name: result[0]['name'], price: result[0]['price'], description: result[0]['description'], host_id: result[0]['host_id'], start_date: result[0]['start_date'], end_date: result[0]['end_date'])
  end

  def self.find(id:)
    result = DatabaseConnection.query("SELECT * FROM listings WHERE id = '#{id}';")
    Listing.new(id: result[0]['id'], name: result[0]['name'], price: result[0]['price'], description: result[0]['description'], host_id: result[0]['host_id'], start_date: result[0]['start_date'], end_date: result[0]['end_date'])
  end

  def self.all
    result = DatabaseConnection.query("SELECT * FROM listings;")
    result.map do |listing|
      Listing.new(id: listing['id'], name: listing['name'], price: listing['price'], description: listing['description'], host_id: listing['host_id'], start_date: listing['start_date'], end_date: listing['end_date'])
    end
  end

  def availability?(start_date, end_date)
    start_date = Date.parse(start_date)
    end_date = Date.parse(end_date)
    if ((start_date.mjd - @available_dates[0].mjd) >= 0) && ((end_date.mjd - @available_dates[0].mjd) > 0)
      # check both before the end available date
      if ((@available_dates[1].mjd - start_date.mjd) > 0) && ((@available_dates[1].mjd - end_date.mjd) >= 0)
        bookings = self.get_bookings(id: self.id)
        if bookings.length > 0
          bookings.each do |booking|
            if (start_date > booking.start_date && start_date < booking.end_date) || (end_date > booking.start_date && end_date < booking.end_date)
              false
            end
          end
          true
        end
      else
        false
      end
    else
      false
    end
  end

  private
  def self.get_bookings(id:)
    result = DatabaseConnection.query("SELECT * FROM bookings WHERE listing_id = #{id};")
    result.map do |booking|
      Booking.new(id: result[0]['id'], listing_id: result[0]['listing_id'], user_id: result[0]['user_id'], start_date: result[0]['start_date'], end_date: result[0]['end_date'], price_total: result[0]['price_total'], confirmation: result[0]['confirmation'])
    end
  end

end
