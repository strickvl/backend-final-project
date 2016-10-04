-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.


-- The template file tournament.sql is where you will put the database schema, in the form of SQL create table commands. Give your tables names that make sense to you, and give the columns descriptive names. You'll also need to create the database itself; see below.

-- connects to the tournament database
\c tournament

-- creates the initial table of 'players' for the database
-- populates it with a name and serial id (allocated as primary key)
create table players (id serial primary key, name text);

-- creates the intial blank table of 'matches' for the database
-- populates it with a serial id (allocated as primary key) for each match
-- and also a record of who was playing who

create table matches (id serial primary key, player1 integer references players, player2 integer references players, winner integer references players);

-- THIS AREA RESERVED FOR CREATING VIEWS

