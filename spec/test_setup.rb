require 'pg'

def clear_test_db
  connection = PG.connect(dbname: 'bnb_test')
  connection.exec("TRUNCATE users CASCADE;")
end