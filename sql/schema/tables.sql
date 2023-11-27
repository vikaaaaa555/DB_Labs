CREATE TABLE IF NOT EXISTS role
(
	id SMALLSERIAL PRIMARY KEY,
	role_type VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS users
(
	id SMALLSERIAL PRIMARY KEY,
	login VARCHAR(20) NOT NULL UNIQUE,
	password VARCHAR(20) NOT NULL,
	role_id SMALLINT NOT NULL,
	
	FOREIGN KEY (role_id) REFERENCES role (id),
	CHECK (login ~ '^[A-Za-z0-9_]+$'),
	CHECK (password ~ '^[a-zA-Z0-9\-_@%]+$')
);

CREATE TABLE IF NOT EXISTS profile
(
	user_id SMALLINT PRIMARY KEY UNIQUE,
	first_name VARCHAR(30),
	last_name VARCHAR(30),
	email VARCHAR(30),
	phone_number VARCHAR(20),
	birth_date DATE,
	
	FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
	CHECK (first_name ~ '^[a-zA-Z]+$'),
	CHECK (last_name ~ '^[a-zA-Z]+$'),
	CHECK (email ~ '^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'),
	CHECK (phone_number ~ '^\+?[0-9]+$')
);

CREATE TABLE IF NOT EXISTS action_type
(
	id SMALLSERIAL PRIMARY KEY,
	name VARCHAR(30) NOT NULL UNIQUE,
	
	CHECK (name ~ '^[a-zA-Z ]+$')
);

CREATE TABLE IF NOT EXISTS action
(
	id SMALLSERIAL PRIMARY KEY,
	action_time TIMESTAMP NOT NULL,
	user_id SMALLINT,
	action_type_id SMALLINT NOT NULL,
	
	FOREIGN KEY (action_type_id) REFERENCES action_type (id),
	FOREIGN KEY (user_id) REFERENCES users (id) ON CASCADE
);

CREATE TABLE IF NOT EXISTS doc_type
(
	id SMALLSERIAL PRIMARY KEY,
	name VARCHAR(30) NOT NULL UNIQUE,
	
	CHECK (name ~ '^[a-zA-Z ]+$')
);

CREATE OR REPLACE FUNCTION check_author_role(author_id SMALLINT)
RETURNS BOOLEAN AS $$
BEGIN
    RETURN author_id IN (SELECT id FROM users WHERE role_id IN (1, 2));
END;
$$ LANGUAGE plpgsql;

CREATE TABLE IF NOT EXISTS document
(
	id SMALLSERIAL PRIMARY KEY,
	title VARCHAR(50) NOT NULL,
	description TEXT NOT NULL,
	last_change_time TIMESTAMP NOT NULL,
	doc_type_id SMALLINT NOT NULL,
	author_id SMALLINT NOT NULL,
	
	FOREIGN KEY (doc_type_id) REFERENCES doc_type (id),
	FOREIGN KEY (author_id) REFERENCES users (id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS state_system
(
	id SMALLSERIAL PRIMARY KEY,
	system_type VARCHAR(30) NOT NULL UNIQUE,
	description TEXT,
	
	CHECK (system_type ~ '^[a-zA-Z]+$')
);

CREATE TABLE IF NOT EXISTS country
(
	id SMALLSERIAL PRIMARY KEY,
	name VARCHAR(40) NOT NULL UNIQUE,
	capital VARCHAR(30) NOT NULL,
	state_system_id SMALLINT NOT NULL,
	
	FOREIGN KEY (state_system_id) REFERENCES state_system (id),
	CHECK (name ~ '^[a-zA-Z ]+$'),
	CHECK (capital ~ '^[a-zA-Z ]+$')
);

CREATE TABLE IF NOT EXISTS historical_figure
(
	id SMALLSERIAL PRIMARY KEY,
	first_name VARCHAR(45) NOT NULL,
	last_name VARCHAR(45),
	birth_date DATE NOT NULL,
	death_date DATE,
	
	CHECK (first_name ~ '^[a-zA-Z]+$'),
	CHECK (last_name ~ '^[a-zA-Z ]+$')
);

CREATE TABLE IF NOT EXISTS figure_country_doc_linc
(
	historical_figure_id SMALLINT NOT NULL,
	country_id SMALLINT NOT NULL,
	document_id SMALLINT NOT NULL,
	
	PRIMARY KEY (historical_figure_id, country_id, document_id),
	FOREIGN KEY (historical_figure_id) REFERENCES historical_figure (id),
	FOREIGN KEY (country_id) REFERENCES country (id),
	FOREIGN KEY (document_id) REFERENCES document (id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS collection
(
	id SMALLSERIAL PRIMARY KEY,
	name VARCHAR(40) NOT NULL,
	description TEXT
);

CREATE TABLE IF NOT EXISTS user_collection_link
(
	user_id SMALLINT NOT NULL,
	collection_id SMALLINT NOT NULL,
	is_subscribe BOOLEAN DEFAULT false NOT NULL,
	
	PRIMARY KEY (user_id, collection_id),
	FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
	FOREIGN KEY (collection_id) REFERENCES collection (id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS collection_doc_link
(
	collection_id SMALLINT NOT NULL,
	document_id SMALLINT NOT NULL,
	
	FOREIGN KEY (collection_id) REFERENCES collection (id),
	FOREIGN KEY (document_id) REFERENCES document (id) ON DELETE CASCADE
);
