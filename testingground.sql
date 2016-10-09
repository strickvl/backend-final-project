select matches.winner, count(matches.id) as numberofwins from matches group by matches.winner order by numberofwins desc;

select count(*) from players LEFT JOIN matches on players.id = matches.player1 OR players.id = matches.player2 group by players.id;



select formalrankingtableminusmatchesplayed.id, formalrankingtableminusmatchesplayed.name, formalrankingtableminusmatchesplayed.numberofwins, matchesplayed.numberofmatchesplayed from formalrankingtableminusmatchesplayed, matchesplayed where formalrankingtableminusmatchesplayed.id = matchesplayed.id order by numberofwins DESC;



 UNION select numberofwins from listofwins;


formalrankingtableminusmatchesplayed
matchesplayed






select players.id, players.name, listofwins.numberofwins as numberofwins from players join listofwins on players.id = listofwins.winner;




create view listofwins as select matches.winner, count(matches.id) as numberofwins from matches group by matches.winner order by numberofwins desc;
create view formalrankingtableminusmatchesplayed as select players.id, players.name, (select count(matches.id) as numberofwins from matches group by matches.winner order by numberofwins desc) as numberofwins from players left join listofwins on players.id = listofwins.winner;
create view matchesplayed as select players.id as id, count(*) as numberofmatchesplayed from players LEFT JOIN matches on players.id = matches.player1 OR players.id = matches.player2 group by players.id;
-- create view rankingtable as select 