CREATE TABLE IF NOT EXISTS role
(
	id SERIAL PRIMARY KEY,
	role_type VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS users
(
	id SERIAL PRIMARY KEY,
	login VARCHAR(20) NOT NULL UNIQUE,
	password VARCHAR(20) NOT NULL,
	role_id INT NOT NULL,
	
	FOREIGN KEY (role_id) REFERENCES role (id),
	CHECK (login ~ '^[A-Za-z0-9_]$'),
	CHECK (password ~ '^[a-zA-Z0-9\-_@%]+$')
);

CREATE TABLE IF NOT EXISTS profile
(
	user_id SERIAL PRIMARY KEY,
	first_name VARCHAR(30),
	last_name VARCHAR(30),
	email VARCHAR(30) NOT NULL,
	phone_number VARCHAR(20),
	
	FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
	CHECK (first_name ~ '^[a-zA-Z]+$'),
	CHECK (last_name ~ '^[a-zA-Z]+$'),
	CHECK (email ~ '^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'),
	CHECK (phone_number ~ '^\+?[0-9]+$')
);

CREATE TABLE IF NOT EXISTS action_type
(
	id SERIAL PRIMARY KEY,
	name VARCHAR(30) NOT NULL UNIQUE,
	
	CHECK (name ~ '^[a-zA-Z]+$')
);

CREATE TABLE IF NOT EXISTS action
(
	id SERIAL PRIMARY KEY,
	action_time TIMESTAMP NOT NULL,
	user_id INT,
	action_type_id INT NOT NULL,
	
	FOREIGN KEY (action_type_id) REFERENCES action_type (id),
	FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS doc_type
(
	id SERIAL PRIMARY KEY,
	name VARCHAR(30) NOT NULL UNIQUE,
	
	CHECK (name ~ '^[a-zA-Z]+$')
);

CREATE TABLE IF NOT EXISTS document
(
	id SERIAL PRIMARY KEY,
	title VARCHAR(50) NOT NULL,
	description TEXT NOT NULL,
	last_change_time TIMESTAMP NOT NULL,
	doc_type_id INT NOT NULL,
	
	FOREIGN KEY (doc_type_id) REFERENCES doc_type (id)
);

CREATE TABLE IF NOT EXISTS state_system
(
	id SERIAL PRIMARY KEY,
	system_type VARCHAR(30) NOT NULL UNIQUE,
	description TEXT,
	
	CHECK (system_type ~ '^[a-zA-Z]+$')
);

CREATE TABLE IF NOT EXISTS countrie
(
	id SERIAL PRIMARY KEY,
	name VARCHAR(40) NOT NULL UNIQUE,
	capital VARCHAR(30) NOT NULL,
	state_system_id INT NOT NULL,
	
	FOREIGN KEY (state_system_id) REFERENCES state_system (id),
	CHECK (name ~ '^[a-zA-Z]+$'),
	CHECK (capital ~ '^[a-zA-Z]+$')
);

CREATE TABLE IF NOT EXISTS historical_figure
(
	id SERIAL PRIMARY KEY,
	first_name VARCHAR(45) NOT NULL,
	last_name VARCHAR(45) NOT NULL,
	birth_date DATE NOT NULL,
	death_date DATE,
	
	CHECK (first_name ~ '^[a-zA-Z]+$'),
	CHECK (last_name ~ '^[a-zA-Z]+$')
);

CREATE TABLE IF NOT EXISTS figure_countrie_doc_linc
(
	historical_figure_id INT NOT NULL,
	countrie_id INT NOT NULL,
	document_id INT NOT NULL,
	
	PRIMARY KEY (historical_figure_id, countrie_id, document_id),
	FOREIGN KEY (historical_figure_id) REFERENCES historical_figure (id),
	FOREIGN KEY (countrie_id) REFERENCES countrie (id),
	FOREIGN KEY (document_id) REFERENCES document (id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS collection
(
	id SERIAL PRIMARY KEY,
	name VARCHAR(40) NOT NULL,
	description TEXT
);

CREATE TABLE IF NOT EXISTS user_collection_link
(
	user_id INT NOT NULL,
	collection_id INT NOT NULL,
	is_subscribe BOOLEAN,
	
	PRIMARY KEY (user_id, collection_id),
	FOREIGN KEY (user_id) REFERENCES users (id),
	FOREIGN KEY (collection_id) REFERENCES collection (id)
);

CREATE TABLE IF NOT EXISTS collection_doc_link
(
	collection_id INT NOT NULL,
	document_id INT NOT NULL,
	
	FOREIGN KEY (collection_id) REFERENCES collection (id),
	FOREIGN KEY (document_id) REFERENCES collection (id) ON DELETE CASCADE
);