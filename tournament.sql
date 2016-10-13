-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.


-- The template file tournament.sql is where you will put the database schema, in the form of SQL create table commands. Give your tables names that make sense to you, and give the columns descriptive names. You'll also need to create the database itself; see below.

-- connects to the tournament database
DROP DATABASE IF EXISTS tournament;
CREATE DATABASE tournament;
\c tournament

-- creates the initial table of 'players' for the database
-- populates it with a name and serial id (allocated as primary key)

--drop table if exists players;
create table players (
	id serial primary key,
	name text
	);

-- creates the intial blank table of 'matches' for the database
-- populates it with a serial id (allocated as primary key) for each match
-- and also a record of who was playing who

-- drop table if exists matches;
create table matches (
	id serial primary key,
	winner integer references players(id),
	loser integer references players(id)
	);

-- creates a view specifying how many wins all the players have had
create view listofwins as select players.id, players.name, count(matches.id) as numberofwins from players left join matches on matches.winner = players.id group by matches.winner, players.id, players.name order by numberofwins desc;

-- creates a view specifying how many matches all the players have played
create view matchesplayed as select players.id as id, count(*) as numberofmatchesplayed from players LEFT JOIN matches on players.id = matches.winner OR players.id = matches.loser group by players.id order by players.id;

-- creates a view combining listofwins and matches played to generate the final ranking table
-- this fulfills the requirements for the function playerStandings
create view finalrankingtable as select listofwins.id, listofwins.name, listofwins.numberofwins as wins, matchesplayed.numberofmatchesplayed as matches from listofwins, matchesplayed where listofwins.id = matchesplayed.id order by numberofwins DESC;