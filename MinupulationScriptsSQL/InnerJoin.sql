SELECT CarRegistrationNumber, Brand, Model
FROM car
INNER JOIN carpolicyclient
ON car.AutomobileId = carpolicyclient.AutomobileId
WHERE car.AutomobileId BETWEEN 10 AND 18;