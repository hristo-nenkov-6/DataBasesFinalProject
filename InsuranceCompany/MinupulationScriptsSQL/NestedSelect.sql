SELECT FirstName, LastName, Income, Gender 
FROM `Client` as c
LEFT JOIN Payment as p
ON p.ClientId = p.ClientId
WHERE c.income > (SELECT AVG(AmountPaid) 
				  FROM Invoice
                  WHERE c.Gender = 'Male');
