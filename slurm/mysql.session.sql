USE test;

SELECT player AS playerID, username, numberDistinctFoodItemsPurchased
FROM (SELECT player,COUNT(item) AS numberDistinctFoodItemsPurchased
FROM purchase
WHERE item IN(
    SELECT id FROM item
    WHERE type='F') 
GROUP BY player
HAVING numberDistinctFoodItemsPurchased >= (SELECT COUNT(id) FROM item
    WHERE type='F')
    ) AS FoodItemsPurchasedRes INNER JOIN player
    ON FoodItemsPurchasedRes.player = player.id;

SELECT P1, MIN(X) AS distanceX
FROM 
(SELECT DISTINCT ph1.player AS P1, ph2.player AS P2, 
MIN(SQRT(POW(ph1.latitude-ph2.latitude,2) + POW(ph1.longitude-ph2.longitude,2)) * 100) AS X
FROM (select player,latitude,longitude 
FROM phonemon 
WHERE player IS NOT NULL 
ORDER BY player) AS ph1
INNER JOIN
(select player,latitude,longitude 
FROM phonemon 
WHERE player IS NOT NULL 
ORDER BY player) AS ph2
ON ph1.player < ph2.player
GROUP BY ph1.player,ph2.player) AS pairX
GROUP BY P1
ORDER BY distanceX,ph1.player 

SELECT username, title
FROM type INNER JOIN
(SELECT username, type
FROM player INNER JOIN (
    SELECT species.type1 AS type, player 
    FROM phonemon INNER JOIN species
    ON phonemon.species=species.id
    UNION
    SELECT species.type2 AS type, player 
    FROM phonemon INNER JOIN species
    ON phonemon.species=species.id
    WHERE species.type2 IS NOT NULL
) AS player_sp_records_inner
ON player.id = player_sp_records_inner.player) 
AS player_sp_records_outter
ON type.id = player_sp_records_outter.type