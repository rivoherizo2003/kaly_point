-- 1. Désactivation temporaire des contraintes de clés étrangères pour faciliter la suppression
PRAGMA foreign_keys = OFF;

-- 2. Suppression des données existantes (pour repartir à zéro)
DELETE FROM check_point_person;
DELETE FROM session_person;
DELETE FROM check_points;
DELETE FROM sessions;
DELETE FROM person;

-- 3. Réinitialisation des compteurs d'ID (AUTOINCREMENT) à 1
DELETE FROM sqlite_sequence WHERE name IN ('person', 'sessions', 'check_points', 'session_person', 'check_point_person');

-- 4. Réactivation des contraintes de clés étrangères
PRAGMA foreign_keys = ON;

-- ==============================================
-- 1. INSERTION DES PERSONNES (100 lignes)
-- ==============================================
INSERT INTO person (lastname, firstname, created_at) VALUES 
('Rakoto', 'Jean', '2023-01-01 10:00:00'), ('Rasoa', 'Marie', '2023-01-02 11:30:00'), ('Andria', 'Tojo', '2023-01-03 09:15:00'), ('Rabe', 'Lanto', '2023-01-04 14:20:00'), ('Rajaona', 'Mialy', '2023-01-05 08:45:00'), ('Randria', 'Tahina', '2023-01-06 16:10:00'), ('Razafy', 'Kanto', '2023-01-07 13:00:00'), ('Rabearivelo', 'Nirina', '2023-01-08 10:40:00'), ('Rano', 'Faly', '2023-01-09 11:55:00'), ('Rakotondrabe', 'Riana', '2023-01-10 15:30:00'),
('Ratsimba', 'Hery', '2023-01-11 09:00:00'), ('Rakotomavo', 'Sitraka', '2023-01-12 12:20:00'), ('Andrianina', 'Bodo', '2023-01-13 14:15:00'), ('Rabenjamina', 'Tiana', '2023-01-14 08:30:00'), ('Rakotondrasoa', 'Mendrika', '2023-01-15 16:45:00'), ('Razafindrabe', 'Haja', '2023-01-16 10:10:00'), ('Rasolonjatovo', 'Vola', '2023-01-17 11:25:00'), ('Ranaivo', 'Zo', '2023-01-18 13:50:00'), ('Ramano', 'Liva', '2023-01-19 09:35:00'), ('Ratsivalaka', 'Miora', '2023-01-20 15:05:00'),
('Dupont', 'Pierre', '2023-02-20 16:15:00'), ('Martin', 'Sophie', '2023-02-21 08:50:00'), ('Bernard', 'Luc', '2023-02-22 11:20:00'), ('Thomas', 'Claire', '2023-02-23 13:45:00'), ('Petit', 'Julien', '2023-02-24 09:10:00'), ('Robert', 'Julie', '2023-02-25 15:35:00'), ('Richard', 'Antoine', '2023-02-26 14:00:00'), ('Durand', 'Celine', '2023-02-27 10:25:00'), ('Dubois', 'Nicolas', '2023-02-28 12:40:00'), ('Moreau', 'Camille', '2023-03-01 16:05:00'),
('Laurent', 'Paul', '2023-03-02 08:30:00'), ('Simon', 'Elodie', '2023-03-03 11:55:00'), ('Michel', 'Romain', '2023-03-04 13:20:00'), ('Lefebvre', 'Marion', '2023-03-05 09:45:00'), ('Leroy', 'Thomas', '2023-03-06 15:10:00'), ('Roux', 'Laura', '2023-03-07 14:25:00'), ('David', 'Alex', '2023-03-08 10:50:00'), ('Bertrand', 'Chloe', '2023-03-09 12:15:00'), ('Morel', 'Kevin', '2023-03-10 16:40:00'), ('Fournier', 'Alice', '2023-03-11 08:15:00'),
('Girard', 'Florian', '2023-03-12 11:40:00'), ('Bonnet', 'Sarah', '2023-03-13 13:05:00'), ('Francois', 'Guillaume', '2023-03-14 09:30:00'), ('Martinez', 'Emma', '2023-03-15 15:55:00'), ('Garcia', 'Lucas', '2023-03-16 14:20:00'), ('Lopez', 'Anais', '2023-03-17 10:45:00'), ('Perez', 'Maxime', '2023-03-18 12:00:00'), ('Sanchez', 'Manon', '2023-03-19 16:25:00'), ('Gomez', 'Quentin', '2023-03-20 08:50:00'), ('Fernandez', 'Lola', '2023-03-21 11:15:00'),
('Cruz', 'Hugo', '2023-03-22 13:40:00'), ('Ortiz', 'Ines', '2023-03-23 09:05:00'), ('Gomez', 'Leo', '2023-03-24 15:30:00'), ('Reyes', 'Lea', '2023-03-25 14:55:00'), ('Ruiz', 'Arthur', '2023-03-26 10:20:00'), ('Morales', 'Zoe', '2023-03-27 12:45:00'), ('Gutierrez', 'Nathan', '2023-03-28 16:10:00'), ('Alvarez', 'Mila', '2023-03-29 08:35:00'), ('Castillo', 'Louis', '2023-03-30 11:00:00'), ('Romero', 'Jade', '2023-03-31 13:25:00'),
('Chavez', 'Gabin', '2023-04-01 09:50:00'), ('Ramos', 'Ambre', '2023-04-02 15:15:00'), ('Flores', 'Raphael', '2023-04-03 14:40:00'), ('Herrera', 'Lena', '2023-04-04 10:05:00'), ('Medina', 'Sacha', '2023-04-05 12:30:00'), ('Aguilar', 'Agathe', '2023-04-06 16:55:00'), ('Castro', 'Jules', '2023-04-07 08:20:00'), ('Vargas', 'Juliette', '2023-04-08 11:45:00'), ('Guzman', 'Gaspard', '2023-04-09 13:10:00'), ('Mendez', 'Victoire', '2023-04-10 09:35:00'),
('Andriantsalama', 'Solo', '2023-01-21 14:00:00'), ('Rakotoarisoa', 'Noro', '2023-01-22 10:45:00'), ('Randriamanantena', 'Fara', '2023-01-23 12:10:00'), ('Rasoamanana', 'Tina', '2023-01-24 16:25:00'), ('Razafimahaleo', 'Njaka', '2023-01-25 08:55:00'), ('Rabemananjara', 'Lova', '2023-01-26 11:40:00'), ('Rakotoarivelo', 'Hasina', '2023-01-27 13:15:00'), ('Randrianarisoa', 'Mano', '2023-01-28 09:20:00'), ('Ratsirahonana', 'Ravo', '2023-01-29 15:35:00'), ('Rakotonirina', 'Nony', '2023-01-30 14:50:00'),
('Andriamampionona', 'Hery', '2023-01-31 10:15:00'), ('Rasoanirina', 'Tantely', '2023-02-01 12:30:00'), ('Razafindrakoto', 'Njary', '2023-02-02 16:05:00'), ('Rakotozafy', 'Rado', '2023-02-03 08:40:00'), ('Randriamampionona', 'Vony', '2023-02-04 11:55:00'), ('Rasolofo', 'Tovo', '2023-02-05 13:20:00'), ('Rabearisoa', 'Miangaly', '2023-02-06 09:45:00'), ('Rakotondranaivo', 'Herizo', '2023-02-07 15:10:00'), ('Razafindranaivo', 'Nantenaina', '2023-02-08 14:25:00'), ('Randrianaivo', 'Fitia', '2023-02-09 10:50:00');

-- ==============================================
-- 2. INSERTION DES SESSIONS (100 lignes - Thème Repas)
-- ==============================================
INSERT INTO sessions (title, description, created_at) VALUES 
('Petit-déjeuner : Tendances Tech 2023', 'Discussion autour d''un café sur l''avenir de l''IA', '2023-01-05 08:00:00'),
('Déjeuner partage : Architecture Hexagonale', 'Retour d''expérience sur l''architecture logicielle en mangeant', '2023-01-10 12:30:00'),
('Dîner Networking Dev', 'Rencontre des équipes techniques autour d''un repas', '2023-01-15 19:00:00'),
('Brunch & Brainstorming', 'Idéation produit un dimanche matin', '2023-01-20 10:30:00'),
('Goûter d''équipe : Bilan Sprint', 'Rétrospective autour de viennoiseries', '2023-01-25 16:00:00'),
('Déjeuner Sécurité Informatique', 'Comment sécuriser ses API (Présentation et pizzas)', '2023-01-30 12:30:00'),
('Dîner de bienvenue des nouveaux', 'Intégration des nouvelles recrues au restaurant', '2023-02-04 19:30:00'),
('Petit-déjeuner : Santé mentale des devs', 'Partage d''expériences et conseils bien-être', '2023-02-09 08:30:00'),
('Potluck du vendredi : Démo projet', 'Chacun apporte un plat, présentation des projets du mois', '2023-02-14 12:30:00'),
('Café & Code : Revue de PR', 'Code review collaborative du matin', '2023-02-19 09:00:00'),
('Déjeuner Burger & Cloud AWS', 'Les nouveautés AWS re:Invent expliquées', '2023-02-24 12:00:00'),
('Dîner d''adieu de l''équipe QA', 'Pot de départ et repas pour l''équipe qualité', '2023-03-01 20:00:00'),
('Brunch des Leaders', 'Alignement stratégique des managers', '2023-03-05 11:00:00'),
('Petit-déjeuner Scrum', 'Comment optimiser nos stand-ups quotidiens', '2023-03-10 08:30:00'),
('Déjeuner : Retour de conférence', 'Partage des apprentissages du DevFest', '2023-03-15 12:30:00'),
('Apéro dînatoire : Lancement v2.0', 'Célébration de la mise en production', '2023-03-20 18:30:00'),
('Déjeuner Salade & SQL', 'Optimisation des requêtes complexes', '2023-03-25 12:00:00'),
('Dîner Hackathon - Nuit 1', 'Ravitaillement pour la première nuit de code', '2023-03-30 21:00:00'),
('Petit-déjeuner UX/UI', 'Critique des nouveaux designs autour de croissants', '2023-04-04 09:00:00'),
('Déjeuner Tacos & TypeScript', 'Migration du projet legacy vers TS', '2023-04-09 12:30:00'),
('Session 21 - Déjeuner Partage', 'Sujet libre autour d''un repas', '2023-04-14 12:30:00'), ('Session 22 - Dîner Partage', 'Sujet libre autour d''un repas', '2023-04-15 19:30:00'),
('Session 23 - Brunch Partage', 'Sujet libre autour d''un repas', '2023-04-16 11:00:00'), ('Session 24 - Petit-déjeuner Partage', 'Sujet libre autour d''un repas', '2023-04-17 08:30:00'),
('Session 25 - Goûter Partage', 'Sujet libre autour d''un repas', '2023-04-18 16:00:00'), ('Session 26 - Déjeuner Partage', 'Sujet libre autour d''un repas', '2023-04-19 12:30:00'),
('Session 27 - Dîner Partage', 'Sujet libre autour d''un repas', '2023-04-20 19:30:00'), ('Session 28 - Brunch Partage', 'Sujet libre autour d''un repas', '2023-04-21 11:00:00'),
('Session 29 - Petit-déjeuner Partage', 'Sujet libre autour d''un repas', '2023-04-22 08:30:00'), ('Session 30 - Goûter Partage', 'Sujet libre autour d''un repas', '2023-04-23 16:00:00'),
('Session 31 - Déjeuner Partage', 'Sujet libre autour d''un repas', '2023-04-24 12:30:00'), ('Session 32 - Dîner Partage', 'Sujet libre autour d''un repas', '2023-04-25 19:30:00'),
('Session 33 - Brunch Partage', 'Sujet libre autour d''un repas', '2023-04-26 11:00:00'), ('Session 34 - Petit-déjeuner Partage', 'Sujet libre autour d''un repas', '2023-04-27 08:30:00'),
('Session 35 - Goûter Partage', 'Sujet libre autour d''un repas', '2023-04-28 16:00:00'), ('Session 36 - Déjeuner Partage', 'Sujet libre autour d''un repas', '2023-04-29 12:30:00'),
('Session 37 - Dîner Partage', 'Sujet libre autour d''un repas', '2023-04-30 19:30:00'), ('Session 38 - Brunch Partage', 'Sujet libre autour d''un repas', '2023-05-01 11:00:00'),
('Session 39 - Petit-déjeuner Partage', 'Sujet libre autour d''un repas', '2023-05-02 08:30:00'), ('Session 40 - Goûter Partage', 'Sujet libre autour d''un repas', '2023-05-03 16:00:00'),
('Session 41 - Déjeuner Partage', 'Sujet libre autour d''un repas', '2023-05-04 12:30:00'), ('Session 42 - Dîner Partage', 'Sujet libre autour d''un repas', '2023-05-05 19:30:00'),
('Session 43 - Brunch Partage', 'Sujet libre autour d''un repas', '2023-05-06 11:00:00'), ('Session 44 - Petit-déjeuner Partage', 'Sujet libre autour d''un repas', '2023-05-07 08:30:00'),
('Session 45 - Goûter Partage', 'Sujet libre autour d''un repas', '2023-05-08 16:00:00'), ('Session 46 - Déjeuner Partage', 'Sujet libre autour d''un repas', '2023-05-09 12:30:00'),
('Session 47 - Dîner Partage', 'Sujet libre autour d''un repas', '2023-05-10 19:30:00'), ('Session 48 - Brunch Partage', 'Sujet libre autour d''un repas', '2023-05-11 11:00:00'),
('Session 49 - Petit-déjeuner Partage', 'Sujet libre autour d''un repas', '2023-05-12 08:30:00'), ('Session 50 - Goûter Partage', 'Sujet libre autour d''un repas', '2023-05-13 16:00:00'),
('Session 51 - Déjeuner Partage', 'Sujet libre autour d''un repas', '2023-05-14 12:30:00'), ('Session 52 - Dîner Partage', 'Sujet libre autour d''un repas', '2023-05-15 19:30:00'),
('Session 53 - Brunch Partage', 'Sujet libre autour d''un repas', '2023-05-16 11:00:00'), ('Session 54 - Petit-déjeuner Partage', 'Sujet libre autour d''un repas', '2023-05-17 08:30:00'),
('Session 55 - Goûter Partage', 'Sujet libre autour d''un repas', '2023-05-18 16:00:00'), ('Session 56 - Déjeuner Partage', 'Sujet libre autour d''un repas', '2023-05-19 12:30:00'),
('Session 57 - Dîner Partage', 'Sujet libre autour d''un repas', '2023-05-20 19:30:00'), ('Session 58 - Brunch Partage', 'Sujet libre autour d''un repas', '2023-05-21 11:00:00'),
('Session 59 - Petit-déjeuner Partage', 'Sujet libre autour d''un repas', '2023-05-22 08:30:00'), ('Session 60 - Goûter Partage', 'Sujet libre autour d''un repas', '2023-05-23 16:00:00'),
('Session 61 - Déjeuner Partage', 'Sujet libre autour d''un repas', '2023-05-24 12:30:00'), ('Session 62 - Dîner Partage', 'Sujet libre autour d''un repas', '2023-05-25 19:30:00'),
('Session 63 - Brunch Partage', 'Sujet libre autour d''un repas', '2023-05-26 11:00:00'), ('Session 64 - Petit-déjeuner Partage', 'Sujet libre autour d''un repas', '2023-05-27 08:30:00'),
('Session 65 - Goûter Partage', 'Sujet libre autour d''un repas', '2023-05-28 16:00:00'), ('Session 66 - Déjeuner Partage', 'Sujet libre autour d''un repas', '2023-05-29 12:30:00'),
('Session 67 - Dîner Partage', 'Sujet libre autour d''un repas', '2023-05-30 19:30:00'), ('Session 68 - Brunch Partage', 'Sujet libre autour d''un repas', '2023-05-31 11:00:00'),
('Session 69 - Petit-déjeuner Partage', 'Sujet libre autour d''un repas', '2023-06-01 08:30:00'), ('Session 70 - Goûter Partage', 'Sujet libre autour d''un repas', '2023-06-02 16:00:00'),
('Session 71 - Déjeuner Partage', 'Sujet libre autour d''un repas', '2023-06-03 12:30:00'), ('Session 72 - Dîner Partage', 'Sujet libre autour d''un repas', '2023-06-04 19:30:00'),
('Session 73 - Brunch Partage', 'Sujet libre autour d''un repas', '2023-06-05 11:00:00'), ('Session 74 - Petit-déjeuner Partage', 'Sujet libre autour d''un repas', '2023-06-06 08:30:00'),
('Session 75 - Goûter Partage', 'Sujet libre autour d''un repas', '2023-06-07 16:00:00'), ('Session 76 - Déjeuner Partage', 'Sujet libre autour d''un repas', '2023-06-08 12:30:00'),
('Session 77 - Dîner Partage', 'Sujet libre autour d''un repas', '2023-06-09 19:30:00'), ('Session 78 - Brunch Partage', 'Sujet libre autour d''un repas', '2023-06-10 11:00:00'),
('Session 79 - Petit-déjeuner Partage', 'Sujet libre autour d''un repas', '2023-06-11 08:30:00'), ('Session 80 - Goûter Partage', 'Sujet libre autour d''un repas', '2023-06-12 16:00:00'),
('Session 81 - Déjeuner Partage', 'Sujet libre autour d''un repas', '2023-06-13 12:30:00'), ('Session 82 - Dîner Partage', 'Sujet libre autour d''un repas', '2023-06-14 19:30:00'),
('Session 83 - Brunch Partage', 'Sujet libre autour d''un repas', '2023-06-15 11:00:00'), ('Session 84 - Petit-déjeuner Partage', 'Sujet libre autour d''un repas', '2023-06-16 08:30:00'),
('Session 85 - Goûter Partage', 'Sujet libre autour d''un repas', '2023-06-17 16:00:00'), ('Session 86 - Déjeuner Partage', 'Sujet libre autour d''un repas', '2023-06-18 12:30:00'),
('Session 87 - Dîner Partage', 'Sujet libre autour d''un repas', '2023-06-19 19:30:00'), ('Session 88 - Brunch Partage', 'Sujet libre autour d''un repas', '2023-06-20 11:00:00'),
('Session 89 - Petit-déjeuner Partage', 'Sujet libre autour d''un repas', '2023-06-21 08:30:00'), ('Session 90 - Goûter Partage', 'Sujet libre autour d''un repas', '2023-06-22 16:00:00'),
('Session 91 - Déjeuner Partage', 'Sujet libre autour d''un repas', '2023-06-23 12:30:00'), ('Session 92 - Dîner Partage', 'Sujet libre autour d''un repas', '2023-06-24 19:30:00'),
('Session 93 - Brunch Partage', 'Sujet libre autour d''un repas', '2023-06-25 11:00:00'), ('Session 94 - Petit-déjeuner Partage', 'Sujet libre autour d''un repas', '2023-06-26 08:30:00'),
('Session 95 - Goûter Partage', 'Sujet libre autour d''un repas', '2023-06-27 16:00:00'), ('Session 96 - Déjeuner Partage', 'Sujet libre autour d''un repas', '2023-06-28 12:30:00'),
('Session 97 - Dîner Partage', 'Sujet libre autour d''un repas', '2023-06-29 19:30:00'), ('Session 98 - Brunch Partage', 'Sujet libre autour d''un repas', '2023-06-30 11:00:00'),
('Session 99 - Petit-déjeuner Partage', 'Sujet libre autour d''un repas', '2023-07-01 08:30:00'), ('Session 100 - Banquet de fin d''année', 'Grand repas de célébration de l''entreprise', '2023-07-02 19:00:00');

-- ==============================================
-- 3. INSERTION : session_person 
-- (50 personnes par session = 5 000 lignes)
-- ==============================================
INSERT INTO session_person (person_id, session_id, created_at)
SELECT p.id, s.id, '2023-01-01 12:00:00'
FROM sessions s
JOIN person p ON p.id <= 50; 
-- Associe les 50 premières personnes à CHAQUE session.

-- ==============================================
-- 4. INSERTION : check_points
-- (100 check-points par session = 10 000 lignes)
-- Utilisation d'une table temporaire récursive (CTE)
-- ==============================================
WITH RECURSIVE cnt(x) AS (
    SELECT 1 
    UNION ALL 
    SELECT x+1 FROM cnt WHERE x < 100
)
INSERT INTO check_points (session_id, title, description, created_at)
SELECT s.id, 'Point de contrôle ' || cnt.x, 'Contrôle lors du repas', '2023-01-01 12:00:00'
FROM sessions s, cnt;

-- ==============================================
-- 5. INSERTION : check_point_person
-- (50 personnes par check-point = 500 000 lignes)
-- ==============================================
INSERT INTO check_point_person (person_id, check_point_id, created_at)
SELECT p.id, cp.id, '2023-01-01 12:00:00'
FROM check_points cp
JOIN person p ON p.id <= 50;
-- Associe les 50 premières personnes à CHAQUE check-point.

INSERT INTO product(title, price)
SELECT 'product ' || cnt.x FROM cnt;

WITH RECURSIVE cnt(x) AS (
  SELECT 1, 10.1
  UNION ALL
  SELECT x, x + 0.25 FROM cnt WHERE x < 10
)
SELECT * FROM cnt