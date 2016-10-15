#!/usr/bin/env python
# 
# tournament.py -- implementation of a Swiss-system tournament
#

import psycopg2


def connect(database_name="tournament"):
    try:
        db = psycopg2.connect("dbname={}".format(database_name))
        cursor = db.cursor()
        return db, cursor
    except:
        print("<error message>")

def deleteMatches():
    """Remove all the match records from the database."""
    db, cursor = connect()
    
    query = "delete from matches;"
    cursor.execute(query)

    db.commit()
    db.close()

def deletePlayers():
    """Remove all the player records from the database."""
    db, cursor = connect()
    
    query = "delete from players;"
    cursor.execute(query)

    db.commit()
    db.close()

def countPlayers():
    """Returns the number of players currently registered."""
    db, cursor = connect()
    
    query = "select count(*) from players;"
    cursor.execute(query)
    row = cursor.fetchone()
    countValue = row[0]
    cursor.close()
    db.close()
    return countValue
        
    db.commit()
    db.close()

def registerPlayer(name):
    """Adds a player to the tournament database.
  
    The database assigns a unique serial id number for the player.  (This
    should be handled by your SQL database schema, not in your Python code.)
  
    Args:
      name: the player's full name (need not be unique).
    """
    db, cursor = connect()

    query = "INSERT INTO players (name) VALUES (%s);"
    parameter = (name,)
    cursor.execute(query, parameter)

    db.commit()
    db.close()

def playerStandings():
    """Returns a list of the players and their win records, sorted by wins.

    The first entry in the list should be the player in first place, or a player
    tied for first place if there is currently a tie.

    Returns:
      A list of tuples, each of which contains (id, name, wins, matches):
        id: the player's unique id (assigned by the database)
        name: the player's full name (as registered)
        wins: the number of matches the player has won
        matches: the number of matches the player has played
    """
    db, cursor = connect()

    query = "select * from finalrankingtable;"
    cursor.execute(query)
    standings = cursor.fetchall()
    db.close()
    return standings

def reportMatch(winner, loser):
    """Records the outcome of a single match between two players.

    Args:
      winner:  the id number of the player who won
      loser:  the id number of the player who lost
    """
    db, cursor = connect()
    
    query = "insert into matches (winner, loser) values (%s, %s)"
    cursor.execute(query, (winner, loser))

    db.commit()
    db.close()
 
def swissPairings():
    """Returns a list of pairs of players for the next round of a match.
  
    Assuming that there are an even number of players registered, each player
    appears exactly once in the pairings.  Each player is paired with another
    player with an equal or nearly-equal win record, that is, a player adjacent
    to him or her in the standings.
  
    Returns:
      A list of tuples, each of which contains (id1, name1, id2, name2)
        id1: the first player's unique id
        name1: the first player's name
        id2: the second player's unique id
        name2: the second player's name
    """
    # retreives player standings i.e. id, player, wins, matches
    standings = playerStandings()
    # pairs for next round are stored in this array.
    next_round = []
    # iterates on the standings results. As the results are already in
    # descending order, the pairs can be made using adjacent players, hence the
    # loop is set to interval of 2 to skip to player for next pair
    # in every iteration.
    for i in range(0, len(standings), 2):
        # each iteration picks player attributes (id, name) of current row
        # and next row and adds in the next_round array.
        next_round.append((standings[i][0], standings[i][1], standings[i+1][0], standings[i+1][1]))
    # pairs for next round are returned from here.
    return next_round