require_relative '../lib/database_connection'
require 'date'

def create_user
  DatabaseConnection.query("INSERT INTO users (username, password, email, phone_no) VALUES ('Test', 'Test', 'test@test.com', '11111111111');")
end

def create_booking
  start_date = '2020-12-25'
  end_date = '2020-12-28'
  DatabaseConnection.query("INSERT INTO bookings (listing_id, user_id, start_date, end_date, price_total, confirmation) VALUES (1, 2, '#{start_date}', '#{end_date}', 100.00, false);")
end

def create_listing
  DatabaseConnection.query("INSERT INTO listings (name, price, description, host_id) VALUES ('Test', 50.00, 'This is very nice house', 1);")
end