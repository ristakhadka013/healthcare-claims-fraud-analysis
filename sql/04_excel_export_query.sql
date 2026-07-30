
WITH AllClaims AS (
    SELECT p.Provider, p.PotentialFraud, ip.ClaimID, ip.InscClaimAmtReimbursed, ip.BeneID
    FROM provider p JOIN inpatient ip ON p.Provider = ip.Provider
    UNION ALL
    SELECT p.Provider, p.PotentialFraud, op.ClaimID, op.InscClaimAmtReimbursed, op.BeneID
    FROM provider p JOIN outpatient op ON p.Provider = op.Provider
),
InpatientOnly AS (
    SELECT Provider, COUNT(ClaimID) AS InpatientClaims
    FROM inpatient
    GROUP BY Provider
),
ChronicPerBene AS (
    SELECT BeneID,
        (ChronicCond_Alzheimer + ChronicCond_Heartfailure + ChronicCond_KidneyDisease +
         ChronicCond_Cancer + ChronicCond_ObstrPulmonary + ChronicCond_Depression +
         ChronicCond_Diabetes + ChronicCond_IschemicHeart + ChronicCond_Osteoporasis +
         ChronicCond_rheumatoidarthritis + ChronicCond_stroke) AS TotalChronicCondition
    FROM beneficiary
)
SELECT 
    ac.Provider,
    ac.PotentialFraud,
    COUNT(ac.ClaimID) AS TotalClaims,
    ROUND(AVG(ac.InscClaimAmtReimbursed), 2) AS AvgClaimAmount,
    io.InpatientClaims,
    ROUND(AVG(cpb.TotalChronicCondition), 2) AS AvgChronicCondition
FROM AllClaims ac
LEFT JOIN InpatientOnly io ON ac.Provider = io.Provider
LEFT JOIN ChronicPerBene cpb ON ac.BeneID = cpb.BeneID
GROUP BY ac.Provider, ac.PotentialFraud, io.InpatientClaims;