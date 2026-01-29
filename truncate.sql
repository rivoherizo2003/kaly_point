-- 1. On désactive temporairement les contraintes de clés étrangères pour éviter les blocages
PRAGMA foreign_keys = OFF;

-- 2. On vide les tables (ordre : enfants d'abord, parents ensuite par sécurité)
DELETE FROM check_point_person;
DELETE FROM session_person;
DELETE FROM check_points;
DELETE FROM person;
DELETE FROM sessions;

-- 3. On réinitialise les compteurs d'IDs (Auto-increment) à 0
-- Cette étape est ce qui différencie un simple DELETE d'un vrai TRUNCATE
DELETE FROM sqlite_sequence WHERE name IN ('check_point_person', 'session_person', 'check_points', 'person', 'sessions');

-- 4. On réactive les contraintes
PRAGMA foreign_keys = ON;