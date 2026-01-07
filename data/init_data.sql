INSERT INTO sessions (title, description, createdAt)
WITH RECURSIVE cnt(x) AS (
    SELECT 1
    UNION ALL
    SELECT x + 1 FROM cnt WHERE x < 100
)
SELECT 
    'Session Title ' || x, 
    'Description for session number ' || x, 
    datetime('now', '-' || x || ' days') 
FROM cnt;