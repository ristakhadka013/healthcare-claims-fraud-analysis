/* Business Question : what characteristics distinguish the fraudulent healthcare provider from non-fraudulent healthcare provider
------------------------------------------------------------------- */

use healthcare_fraud_project;

SELECT *
FROM beneficiary
LIMIT 10 ;

SELECT *
FROM inpatient
LIMIT 10 ;

SELECT *
FROM outpatient
LIMIT 10 ;

-- Analysis Question 1 : Do Fraudulent Provider have higher average claim amount?
with TotalClaims as ( 
	select 
	p.PotentialFraud,
	ip.InscClaimAmtReimbursed as InscClaimAmtReimbursed
	from provider p 
	join inpatient ip
	on p.Provider = ip.Provider

	union all
	
	select 
	p.PotentialFraud,
	op.InscClaimAmtReimbursed
	from provider p 
	join outpatient op
	on p.Provider = op.Provider
    )

select 
PotentialFraud,
round(avg(InscClaimAmtReimbursed), 2) as AVGTotalInscClaimAmtReimbursed
from TotalClaims
group by PotentialFraud;

/*----------------------------------------------------------------------....................................
RESULT------------ 
No -> avg 755.21
Yes -> avg 1389.51

FINDINGS ----------------------------------
The fraudulent healthcare provider received higher average Reimbursement per claim (1389.51) 
than non-fraudulent healthcare provider (755.21)
This suggest that fraudulent healthcare providers may submit higher-value claims than non-fraudulent providers.
----------------------------------------------------------------------------------------------------------------*/

-- Analysis Question2. Do fraudulent providers treated more inpatient than non-fraudulent providers?

--FIRST APPROACH
select
p.PotentialFraud,
count(ip.ClaimID) as TotalInpatient,
count(distinct ip.Provider) as TotalProvider,
round((count(ip.ClaimID) / count(distinct ip.Provider)), 2) as Avg_Total_Inpatient
from inpatient ip
join provider p
on ip.Provider = p.Provider
group by p.PotentialFraud;

--SECOND APPROACH
With TotalClaims as (
	SELECT
	p.PotentialFraud,
	ip.Provider,
	COUNT(ip.ClaimID) as TOTALCLAIM
	FROM Inpatient ip
	JOIN provider p
	ON ip.Provider = p.Provider
	GROUP BY Provider, PotentialFraud
)

SELECT 
	PotentialFraud,
	AVG(TOTALCLAIM) as AVGTOTALCLAIM
	FROM TotalClaims
	GROUP BY PotentialFraud;

/* --------------------------------------------------------------------------------------------------------------

RESULT
No	17072	1652	10.33
Yes	23402	440		53.19

FINDINGS------------
The fraudulent healthcare providers treats more inpatient (53.19) in average than non-fraudulent healthcare providers (10.33).

----------------------------------------------------------------------------------------------------------------------------*/

-- Analysis Question 3 : Do fraudulent Provider treat patient with more chronic condition? 

WITH ChronicPerBene AS (
	SELECT 
	BeneID,
	(
		case when ChronicCond_Alzheimer = 1 then 1 else 0 end +
		case when ChronicCond_Heartfailure = 1 then 1 else 0 end  + 
		case when ChronicCond_KidneyDisease = 1 then 1 else 0 end +
		case when ChronicCond_Cancer = 1 then 1 else 0 end +
		case when ChronicCond_ObstrPulmonary = 1 then 1 else 0 end +
		case when ChronicCond_Depression = 1 then 1 else 0 end +
		case when ChronicCond_Diabetes = 1 then 1 else 0 end +
		case when ChronicCond_IschemicHeart = 1 then 1 else 0 end +
		case when ChronicCond_Osteoporasis = 1 then 1 else 0 end +
		case when ChronicCond_rheumatoidarthritis = 1 then 1 else 0 end +
		case when ChronicCond_stroke = 1 then 1 else 0 end
	) as TotalChronicCondition
	from beneficiary
	group by BeneID
),

AllDetails as (
	select 
    distinct p.Provider, p.PotentialFraud, 
	cpb.TotalChronicCondition,
	cpb.BeneID
	from ChronicPerBene cpb
	join inpatient ip 
	on cpb.BeneID = ip.BeneID
	join provider p
	on ip.Provider = p.Provider 
)

select 
PotentialFraud, 
avg(TotalChronicCondition) as avg_TotalChronicCondition 
from AllDetails 
group by potentialFraud;

/* ---------------------------------------------------------------------------------------

RESULT 
Yes	5.3933
No	5.4398

FINDINGS 
The potential fraudulent healthcare provider treated lower average number of chronic conditions (5.3933) 
than non-fraudulent healthcare providers (5.4398).
Unlike Claim amount and inpatient volumn, patient chronic condition doesnot appear to meaningfully distinguish fraudulent
from non-fraudulent providers- suggesting fraud risk may be closely tied to billing rather than patient case complexity 

------------------------------------------------------------------------------------------------------------------------*/

-- Analysis Question 4. Do fraudulent provider treat more older patient ? 

with TotalClaims as ( 
	select 
    ip.BeneID,
	p.PotentialFraud,
	ip.Provider,
    ip.ClaimStartDt
	from provider p 
	join inpatient ip
	on p.Provider = ip.Provider

	union
	
	select 
    op.BeneID,
	p.PotentialFraud,
	op.Provider,
    op.ClaimStartDt
	from provider p 
	join outpatient op
	on p.Provider = op.Provider
)

SELECT
    tc.PotentialFraud,
    AVG(TIMESTAMPDIFF(YEAR, b.DOB, tc.ClaimStartDt)) AS AverageAge
FROM TotalClaims tc
JOIN beneficiary b
    ON tc.BeneID = b.BeneID
GROUP BY tc.PotentialFraud;

/* ---------------------------------------------------------------------------------
RESULT 
Yes	72.9328
No	72.7160

FINDINGS 
Fraudulent healthcare providers patients have a nearly identical average age (72.93) 
compared to non-fraudulent providers patients (72.72).
patient age does not meaningfully distinguish fraud from non-fraud providers.
------------------------------------------------------------------------------------------ */

-- Analysis Question 5. Do fraudulent providers have a higher number of claims?

with InpatientOutpatientClaim as ( 
	select 
	p.PotentialFraud,
	ip.Provider,
    ip.ClaimID
	from provider p 
	join inpatient ip
	on p.Provider = ip.Provider

	union
	
	select 
	p.PotentialFraud,
	op.Provider, 
    op.ClaimID
	from provider p 
	join outpatient op
	on p.Provider = op.Provider
    ),

TotalClaims as (
SELECT 
Provider,
PotentialFraud,
COUNT(ClaimID) as TOTALClaims
FROM InpatientOutpatientClaim 
GROUP BY Provider, PotentialFraud)

SELECT 
PotentialFraud,
ROUND(AVG(TOTALClaims), 2) as AVG_TOTALClaims
FROM TotalClaims
GROUP BY PotentialFraud;

/* ---------------------------------------------------------------------------------
RESULT
No	70.44
Yes	420.55

FINDINGS:
The Fraudulent healthcare provider submitted more claims (420.55) than non-fraudulent health provider (70.44)
This is the largest gap observed so far and suggest that unusually high claim volume is strongly 
associated with fraud risk
------------------------------------------------------------------------------------------------*/
