require_relative 'database_connection'

class Listing

  attr_accessor :name, :price, :description, :available_dates
  attr_reader :id, :host_id

  def initialize(id:, name:, price:, description:, host_id:, start_date:, end_date:)
    @id = id
    @name = name
    @price = price
    @description = description
    @host_id = host_id
    @available_dates = [start_date, end_date]
  end

  def self.create(name:, price:, description:, host_id:, start_date:, end_date:)
    result = DatabaseConnection.query("INSERT INTO listings(name, price, description, host_id, start_date, end_date) VALUES('#{name}', #{price}, '#{description}', #{host_id}, '#{start_date}', '#{end_date}') RETURNING id, name, price, description, host_id, start_date, end_date;")
    Listing.new(id: result[0]['id'], name: result[0]['name'], price: result[0]['price'], description: result[0]['description'], host_id: result[0]['host_id'], start_date: result[0]['start_date'], end_date: result[0]['end_date'])
  end

  def self.find(id:)
    result = DatabaseConnection.query("SELECT * FROM listings WHERE id = '#{id}';")
    Listing.new(id: result[0]['id'], name: result[0]['name'], price: result[0]['price'], description: result[0]['description'], host_id: result[0]['host_id'], start_date: result[0]['start_date'], end_date: result[0]['end_date'])
  end

  def self.all
    result = DatabaseConnection.query("SELECT * FROM listings;")
    result.map do |listing|
      Listing.new(id: listing['id'], name: listing['name'], price: listing['price'], description: listing['description'], host_id: listing[host_id], start_date: listing['start_date'], end_date: listing['end_date'])
    end
  end

  # def self.get_available_dates
  #
  # end
  #
  # def availability?(start_date, end_date)
  #
  # end

end
