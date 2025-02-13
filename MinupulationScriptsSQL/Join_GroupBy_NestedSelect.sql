SELECT d.FirstName, d.LastName,
 Partitial.Brand, Partitial.MaxEngineSize
FROM Driver AS d
LEFT JOIN carpolicyclient AS cpc ON d.DriverId = cpc.DriverId
LEFT JOIN 
(
    SELECT c.Brand, MAX(c.EngineSize) AS MaxEngineSize
    FROM car AS c
    INNER JOIN carpolicyclient AS cpc ON c.AutomobileId = cpc.AutomobileId
    GROUP BY c.Brand
) AS Partitial
ON cpc.AutomobileId = (
    SELECT c2.AutomobileId
    FROM car AS c2
    WHERE c2.Brand = Partitial.Brand
    LIMIT 1
)
WHERE
	Partitial.Brand IS NOT NULL;
