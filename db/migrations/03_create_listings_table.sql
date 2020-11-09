CREATE TABLE listings(id SERIAL PRIMARY KEY, name VARCHAR(40), price NUMERIC, description VARCHAR(500), host_id INTEGER REFERENCES users (id));
