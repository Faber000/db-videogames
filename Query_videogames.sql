-- 1 - Selezionare tutte le software house americane (3)
SELECT *
FROM software_houses
WHERE country = 'United States';

-- 2 - Selezionare tutti i giocatori della città di 'Rogahnland' (2)
SELECT *
FROM players
WHERE city = 'Rogahnland';

-- 3 - Selezionare tutti i giocatori il cui nome finisce per "a" (220)
SELECT *
FROM players
WHERE name LIKE '%a';

-- 4 - Selezionare tutte le recensioni scritte dal giocatore con ID = 800 (11)
SELECT *
FROM reviews
WHERE player_id = 800;

-- 5 - Contare quanti tornei ci sono stati nell'anno 2015 (9)
SELECT COUNT(*)
FROM tournaments
WHERE year = '2015';

-- 6 - Selezionare tutti i premi che contengono nella descrizione la parola 'facere' (2)
SELECT *
FROM awards
WHERE description LIKE '%facere%';

-- 7 - Selezionare tutti i videogame che hanno la categoria 2 (FPS) o 6 (RPG), mostrandoli una sola volta (del videogioco vogliamo solo l'ID) (287)
SELECT DISTINCT videogame_id
FROM category_videogame
WHERE category_id = 2 OR category_id = 6;

-- 8 - Selezionare tutte le recensioni con voto compreso tra 2 e 4 (2947)
SELECT *
FROM reviews
WHERE rating >=2 AND rating <= 4;

-- 9 - Selezionare tutti i dati dei videogiochi rilasciati nell'anno 2020 (46)
SELECT *
FROM videogames
WHERE release_date BETWEEN '01/01/2020' AND '31/12/2020';

-- 10 - Selezionare gli id dei videogame che hanno ricevuto almeno una recensione da 5 stelle, mostrandoli una sola volta (443)
SELECT DISTINCT videogame_id
FROM reviews
WHERE rating = 5;

-- 11 - Selezionare il numero e la media delle recensioni per il videogioco con ID = 412 (review number = 12, avg_rating = 3)
SELECT COUNT(*) AS review_number, AVG(rating) AS avg_rating
FROM reviews
WHERE videogame_id = 412;

-- 12 - Selezionare il numero di videogame che la software house con ID = 1 ha rilasciato nel 2018 (13)
SELECT COUNT(*)
FROM videogames
WHERE software_house_id = 1 AND release_date BETWEEN '01/01/2018' AND '31/12/2018';

-- QUERY CON GROUP BY ---------------------

-- 1 - Contare quante software house ci sono per ogni paese (3)
SELECT COUNT(*)
FROM software_houses
GROUP BY country;

-- 2 - Contare quante recensioni ha ricevuto ogni videogioco (del videogioco vogliamo solo l'ID) (500)
SELECT COUNT(*)
FROM reviews
GROUP BY videogame_id;

-- 3 - Contare quanti videogiochi hanno ciascuna classificazione PEGI (della classificazione PEGI vogliamo solo l'ID) (13)
SELECT COUNT(videogame_id)
FROM pegi_label_videogame
GROUP BY pegi_label_id;

-- 4 - Mostrare il numero di videogiochi rilasciati ogni anno (11)
SELECT COUNT(*)
FROM videogames
GROUP BY YEAR(release_date);

-- 5 - Contare quanti videogiochi sono disponbiili per ciascun device (del device vogliamo solo l'ID) (7)
SELECT COUNT(videogame_id)
FROM device_videogame
GROUP BY device_id;

-- 6 - Ordinare i videogame in base alla media delle recensioni (del videogioco vogliamo solo l'ID) (500)
SELECT videogame_id
FROM reviews
GROUP BY videogame_id
ORDER BY AVG(rating);

-- QUERY CON JOIN --------------------------------

-- 1 - Selezionare i dati di tutti giocatori che hanno scritto almeno una recensione, mostrandoli una sola volta (996)
SELECT DISTINCT players.id, players.name, players.lastname
FROM players
JOIN reviews 
ON players.id = reviews.player_id;

-- 2 - Sezionare tutti i videogame dei tornei tenuti nel 2016, mostrandoli una sola volta (226)
SELECT DISTINCT videogames.name
FROM tournament_videogame
JOIN tournaments
ON tournament_videogame.tournament_id = tournaments.id
JOIN videogames
ON tournament_videogame.videogame_id = videogames.id
AND tournaments.year = 2016

-- 3 - Mostrare le categorie di ogni videogioco (1718)
SELECT videogames.name, categories.name
FROM category_videogame
JOIN videogames
ON category_videogame.videogame_id = videogames.id
JOIN categories
ON category_videogame.category_id = categories.id

-- 4 - Selezionare i dati di tutte le software house che hanno rilasciato almeno un gioco dopo il 2020, mostrandoli una sola volta (6)
SELECT DISTINCT software_houses.id, software_houses.name
FROM software_houses
JOIN videogames
ON software_houses.id = videogames.software_house_id
AND videogames.release_date > '31/12/2020';

-- 5 - Selezionare i premi ricevuti da ogni software house per i videogiochi che ha prodotto (55)
SELECT software_houses.name, awards.name
FROM software_houses
JOIN videogames
ON videogames.software_house_id = software_houses.id
JOIN award_videogame
ON award_videogame.videogame_id = videogames.id
JOIN awards
ON award_videogame.award_id = awards.id

-- 6 - Selezionare categorie e classificazioni PEGI dei videogiochi che hanno ricevuto recensioni da 4 e 5 stelle, mostrandole una sola volta (3363)
SELECT DISTINCT videogames.id, categories.name, pegi_labels.name
FROM category_videogame
JOIN videogames
ON category_videogame.videogame_id = videogames.id
JOIN categories
ON category_videogame.category_id = categories.id
JOIN pegi_label_videogame
ON videogames.id = pegi_label_videogame.videogame_id
JOIN reviews
ON reviews.videogame_id = videogames.id
JOIN pegi_labels
ON pegi_label_videogame.pegi_label_id = pegi_labels.id
AND reviews.rating BETWEEN 4 AND 5

-- 7 - Selezionare quali giochi erano presenti nei tornei nei quali hanno partecipato i giocatori il cui nome inizia per 'S' (474)
SELECT DISTINCT videogames.name
FROM videogames
JOIN tournament_videogame
ON tournament_videogame.videogame_id = videogames.id
JOIN tournaments
ON tournaments.id = tournament_videogame.tournament_id
JOIN player_tournament
ON player_tournament.tournament_id = tournaments.id
JOIN players
ON player_tournament.player_id = players.id
AND players.name LIKE '%S'

-- 8 - Selezionare le città in cui è stato giocato il gioco dell'anno del 2018 (36)
SELECT DISTINCT tournaments.city
FROM tournaments
JOIN tournament_videogame
ON  tournament_videogame.tournament_id = tournaments.id
JOIN videogames
ON tournament_videogame.videogame_id = videogames.id 
JOIN award_videogame
ON  award_videogame.videogame_id = videogames.id 
JOIN awards
ON  award_videogame.award_id = awards.id
AND awards.name ='gioco dell''anno'
AND award_videogame.year = 2018

-- 9 - Selezionare i giocatori che hanno giocato al gioco più atteso del 2018 in un torneo del 2019 (3306)
SELECT DISTINCT players.name
FROM players
JOIN player_tournament
ON player_tournament.player_id = players.id
JOIN tournaments
ON player_tournament.tournament_id = tournaments.id
JOIN tournament_videogame
ON tournament_videogame.tournament_id = tournaments.id
JOIN videogames
ON  tournament_videogame.videogame_id = videogames.id
JOIN award_videogame
ON  award_videogame.videogame_id = videogames.id
JOIN awards 
ON awards.id = award_videogame.award_id
AND awards.name = 'gioco più atteso dell''anno' 
AND award_videogame.year = 2018
AND tournaments.year = 2019