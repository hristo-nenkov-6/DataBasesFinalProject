SELECT COUNT(ClientId) AS `Count of Clients`, Education 
FROM `Client`
GROUP BY Education
ORDER BY COUNT(ClientId);
