SELECT PayerName, AmountPaid, cp.InsuranceType
FROM invoice as i
LEFT JOIN carpolicy as cp
ON i.PolicyId = cp.PolicyId
WHERE i.AmountPaid >= 580;
