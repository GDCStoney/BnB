require 'listing'
require 'database_connection'
require 'db_helpers.rb'

RSpec.describe Listing do
  before(:each) do
    create_user
  end

  describe '.all' do
    it "Returns a list of all listings" do
      create_listing
      expect(Listing.all.length).to eq 1
      expect(Listing.all[0].name).to eq "Test"
    end
  end

  describe '.create' do
    it "Inserts a new listing into db and returns listing object" do
      expect(Listing.create(name: "Test listing", price: 40.00, description: 'Test description', host_id: 1, start_date: '2020-12-25', end_date: '2020-12-28')).to be_an_instance_of(Listing)
    end
  end

  describe '.find' do
    it 'Returns a listing object with details of given ID' do
      listing = Listing.create(name: "Test listing", price: 40.00, description: 'Test description', host_id: 1, start_date: '2020-12-25', end_date: '2020-12-28')
      expect(Listing.find(id: listing.id).name).to eq "Test listing"
    end
  end
end
