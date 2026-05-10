CREATE DATABASE btvn_Ss5;
USE btvn_Ss5;

SELECT restaurant_name, created_at
FROM Restaurants
ORDER BY  created_at DESC
LIMIT 5;