require 'pg'

class DatabaseConnection

  @database

  def self.setup(db_name)
    @database = PG.connect(dbname: db_name)
  end

  def self.query(query)
    @database.exec(query)
  end

  def self.database
    @database
  end

end
