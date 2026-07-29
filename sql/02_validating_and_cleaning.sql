#DATA VALIDATION AND CLEANING

USE healthcare_fraud_project;

# FOR BENEFICIARY .............................................................

DESC beneficiary;

SELECT 
BeneID,
COUNT(*) AS DUPLICATEROWCOUNT 
FROM beneficiary
GROUP BY BeneID 
HAVING COUNT(*) > 1; 

SELECT 
SUM(BeneID IS NULL) AS MISSINGBENEID
FROM beneficiary;

SELECT 
COUNT(*) AS NEGATIVEVALUE
FROM beneficiary
WHERE IPAnnualReimbursementAmt < 0 OR
IPAnnualDeductibleAmt < 0 OR
OPAnnualReimbursementAmt < 0 OR 
OPAnnualDeductibleAmt < 0;
# here there are 27 negative value so lets look differently 

SELECT 
row_number() over (order by BeneId) as ROWNUMBER,
IPAnnualReimbursementAmt
FROM beneficiary
WHERE IPAnnualReimbursementAmt < 0; #15 negative value 

SELECT 
row_number() over (order by BeneId) as ROWNUMBER,
IPAnnualDeductibleAmt
FROM beneficiary
WHERE IPAnnualDeductibleAmt < 0; #0 negative value
 
SELECT 
row_number() over (order by BeneId) as ROWNUMBER,
OPAnnualDeductibleAmt
FROM beneficiary
WHERE OPAnnualDeductibleAmt < 0; #0 negative value

SELECT 
row_number() over (order by BeneId) as ROWNUMBER,
OPAnnualReimbursementAmt
FROM beneficiary
WHERE OPAnnualReimbursementAmt < 0 
ORDER BY OPAnnualReimbursementAmt desc; #12 negative value

/* DATA VALIDATION DECISION 
1. I choose to leave it as it is, because :
		a. Dataset (kaggle) documentation doesnot identify it as an data error
        b. values appear realistic (-200, -10, -100, etc.) and are extremely rare.
2. I added a flag column (HasNegativeAdjustment) to the beneficiary table to mark these 27 rows as adjustment, 
	without altering the orginal value.
*/

ALTER TABLE beneficiary
ADD COLUMN HasNegativeAdjustment TINYINT DEFAULT 0;

SET SQL_SAFE_UPDATES = 0;

UPDATE beneficiary
SET HasNegativeAdjustment = 1
WHERE IPAnnualReimbursementAmt < 0 OR
IPAnnualDeductibleAmt < 0 OR
OPAnnualReimbursementAmt < 0 OR 
OPAnnualDeductibleAmt < 0;

SELECT 
BeneID,
IPAnnualReimbursementAmt,
OPAnnualReimbursementAmt,
HasNegativeAdjustment
FROM beneficiary 
WHERE HasNegativeAdjustment = 1;

SELECT 
COUNT(*) AS IMPOSSIBLEDATE
FROM beneficiary
WHERE DOB > DOD;

SELECT 
COUNT(*) AS IMPOSSIBLEDATE
FROM beneficiary
WHERE DOB > CURDATE();

#..................................................................................................

DESC inpatient;

SELECT *
FROM inpatient 
LIMIT 10;

SELECT 
SUM(BeneID IS NULL) AS MISSINGBENEID,
SUM(ClaimID IS NULL) AS MISSINGCLAIMID,
SUM(Provider IS NULL) AS MISSINGPROVIDER,
SUM(DeductibleAmtPaid IS NULL ) AS MISSINGDeductibleAmtPaid,
SUM(AdmissionDt IS NULL ) AS MISSINGAdmissionDt,
SUM(DischargeDt IS NULL) AS MISSINGDischargeDt
FROM inpatient;  
#HERE I FOUND THAT 3 FIELD HAS MISSING VALUE WHILE LOADING DATA. 
# NOW LETS CHECK THE CSV TABLE HEADER WITH THE SQL FIELDS NAME 
# I FOUND THE ISSUE, WHILE IMPORTING THE DATA I READ THAT THREE COLUMN INTO USER VARIABLE BUT IN SET CLAUSE I FORGOT TO ASSIGN 
# NOW LETS EMPTY THE TABLE AND IMPORT AGAIN , DONE IN 01_SCHEMA_AND_IMPORT FILE

set foreign_key_checks = 0 ;
truncate table inpatient;
set foreign_key_checks = 1;

SELECT 
ClaimID, 
COUNT(*) AS DUPLICATEROW
FROM inpatient
GROUP BY ClaimID
HAVING COUNT(*) > 1;

SELECT 
ClaimID
FROM inpatient
WHERE ClaimStartDt > ClaimEndDt;

SELECT 
ClaimID
FROM inpatient
WHERE AdmissionDt > DischargeDt; 

SELECT 
ClaimID 
FROM inpatient
WHERE InscClaimAmtReimbursed < 0;

SELECT 
ClaimID
FROM inpatient
WHERE DeductibleAmtPaid < 0;

SELECT 
COUNT(*) AS MissingBeneficiaryReference
FROM inpatient i 
LEFT JOIN beneficiary b
ON i.BeneID = b.BeneID
WHERE i.BeneID IS NULL;

SELECT 
COUNT(*) AS MissingProviderReference
FROM inpatient i 
LEFT JOIN provider p
ON i.Provider = p.Provider
WHERE i.Provider IS NULL;

#..........................................................................................................

DESC outpatient;

SELECT *
FROM outpatient 
LIMIT 10;

SELECT 
SUM(BeneID IS NULL) AS MISSINGBENEID,
SUM(ClaimID IS NULL) AS MISSINGCLAIMID,
SUM(Provider IS NULL) AS MISSINGPROVIDER
FROM outpatient; 

SELECT 
ClaimID,
COUNT(*) AS DUPLICATEROW
FROM outpatient
GROUP BY ClaimID 
HAVING COUNT(*) > 1;

SELECT 
ClaimID
FROM outpatient
WHERE ClaimStartDt > ClaimEndDt;

SELECT
ClaimID
FROM outpatient 
WHERE InscClaimAmtReimbursed < 0;

SELECT 
ClaimID
FROM outpatient
WHERE DeductibleAmtPaid < 0;

SELECT 
COUNT(*) AS MissingBeneficiaryReference
FROM outpatient i 
LEFT JOIN beneficiary b
ON i.BeneID = b.BeneID
WHERE i.BeneID IS NULL;

SELECT 
COUNT(*) AS MissingProviderReference
FROM outpatient i 
LEFT JOIN provider p
ON i.provider = p.provider
WHERE i.provider IS NULL;

#...............................................................................................................
DESC provider;

SELECT 
SUM(Provider IS NULL) AS MISSINGPROVIDERID 
FROM Provider;
 
SELECT 
Provider,
COUNT(*) AS DUPLICATEROW
FROM Provider
GROUP BY Provider
HAVING COUNT(*) > 1;

/* DATA VALIDATION SUMMARY

Beneficiary
------------
Duplicates : 0
Missing IDs : 0
Negative values : 27
Impossible dates : 0

Inpatient
----------
Duplicates : 0
Missing values : 0
Negative reimbursement : 0
Foreign key integrity : Passed

Outpatient
-----------
Duplicates : 0
Missing values : 0
Negative reimbursement : 0
Foreign key integrity : Passed

Provider
---------
Duplicates : 0
Missing values : 0 */

/* DATA VALIDATION DECISION 
1. During validation, 27 beneficiaries were found with negative reimbursement values.
Further investigation showed that:

a. Negative value looks realistics (-10, -200, -100) and are extremly rare (27 records)
c. Many beneficiaries also have positive reimbursements in the other reimbursement category, 
	suggesting these represent financial adjustments rather than missing or corrupted data.
d. Dataset documentation does not identify these values as errors.

Therefore, these records were retained and flagged using the HasNegativeAdjustment column.
*/



