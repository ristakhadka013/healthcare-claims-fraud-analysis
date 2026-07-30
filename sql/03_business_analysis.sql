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

select
p.PotentialFraud,
count(ip.ClaimID) as TotalInpatient,
count(distinct ip.Provider) as TotalProvider,
round((count(ip.ClaimID) / count(distinct ip.Provider)), 2) as Avg_Total_Inpatient
from inpatient ip
join provider p
on ip.Provider = p.Provider
group by p.PotentialFraud;

/* --------------------------------------------------------------------------------------------------------------

RESULT
No	17072	1652	10.33
Yes	23402	440		53.19

FINDINGS------------
The fraudulent healthcare providers treats more inpatient (53.19) in average than non-fraudulent healthcare providers (10.33).

----------------------------------------------------------------------------------------------------------------------------*/

-- Anlysis Question 3 : Do fraudulent Provider treat patient with more chronic condition? 

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
The potential fraudulent healthcare provider treated lower average no of chronic condition (5.3933) 
than non-fraudulent healthcare providers (5.4398).
Unlike Claim amount and inpatient volumn, patient chronic condition doesnot appear to meaningfully distinguish fraudulent
from non-fraudulent providers- suggesting fraud risk may be closely tied to billing rather than patient case complexity 

------------------------------------------------------------------------------------------------------------------------*/
