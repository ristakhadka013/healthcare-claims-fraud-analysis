use healthcare_fraud_project;

CREATE TABLE beneficiary (
    BeneID VARCHAR(20) PRIMARY KEY,
    DOB DATE,
    DOD DATE,
    Gender TINYINT,
    Race TINYINT,
    RenalDiseaseIndicator VARCHAR(5),
    State VARCHAR(5),
    County VARCHAR(5),
    NoOfMonths_PartACov INT,
    NoOfMonths_PartBCov INT,
    ChronicCond_Alzheimer TINYINT,
    ChronicCond_Heartfailure TINYINT,
    ChronicCond_KidneyDisease TINYINT,
    ChronicCond_Cancer TINYINT,
    ChronicCond_ObstrPulmonary TINYINT,
    ChronicCond_Depression TINYINT,
    ChronicCond_Diabetes TINYINT,
    ChronicCond_IschemicHeart TINYINT,
    ChronicCond_Osteoporasis TINYINT,
    ChronicCond_rheumatoidarthritis TINYINT,
    ChronicCond_stroke TINYINT,
    IPAnnualReimbursementAmt DECIMAL(10,2),
    IPAnnualDeductibleAmt DECIMAL(10,2),
    OPAnnualReimbursementAmt DECIMAL(10,2),
    OPAnnualDeductibleAmt DECIMAL(10,2)
);

CREATE TABLE provider (
	Provider VARCHAR(20) PRIMARY KEY,
    PotentialFraud VARCHAR(5)
);

CREATE TABLE inpatient (
    BeneID VARCHAR(20),
    ClaimID VARCHAR(20) PRIMARY KEY,
    ClaimStartDt DATE,
    ClaimEndDt DATE,
    Provider VARCHAR(20),
    InscClaimAmtReimbursed DECIMAL(10,2),
    AttendingPhysician VARCHAR(20),
    OperatingPhysician VARCHAR(20),
    OtherPhysician VARCHAR(20),
    AdmissionDt DATE,
    ClmAdmitDiagnosisCode VARCHAR(10),
    DeductibleAmtPaid DECIMAL(10,2),
    DischargeDt DATE,
    DiagnosisGroupCode VARCHAR(10),
    ClmDiagnosisCode_1 VARCHAR(10),
    ClmDiagnosisCode_2 VARCHAR(10),
    ClmDiagnosisCode_3 VARCHAR(10),
    ClmDiagnosisCode_4 VARCHAR(10),
    ClmDiagnosisCode_5 VARCHAR(10),
    ClmDiagnosisCode_6 VARCHAR(10),
    ClmDiagnosisCode_7 VARCHAR(10),
    ClmDiagnosisCode_8 VARCHAR(10),
    ClmDiagnosisCode_9 VARCHAR(10),
    ClmDiagnosisCode_10 VARCHAR(10),
    ClmProcedureCode_1 VARCHAR(10),
    ClmProcedureCode_2 VARCHAR(10),
    ClmProcedureCode_3 VARCHAR(10),
    ClmProcedureCode_4 VARCHAR(10),
    ClmProcedureCode_5 VARCHAR(10),
    ClmProcedureCode_6 VARCHAR(10),
    FOREIGN KEY (BeneID) REFERENCES beneficiary(BeneID),
    FOREIGN KEY (Provider) REFERENCES provider(Provider)
);

CREATE TABLE outpatient (
    BeneID VARCHAR(20),
    ClaimID VARCHAR(20) PRIMARY KEY,
    ClaimStartDt DATE,
    ClaimEndDt DATE,
    Provider VARCHAR(20),
    InscClaimAmtReimbursed DECIMAL(10,2),
    AttendingPhysician VARCHAR(20),
    OperatingPhysician VARCHAR(20),
    OtherPhysician VARCHAR(20),
    ClmDiagnosisCode_1 VARCHAR(10),
    ClmDiagnosisCode_2 VARCHAR(10),
    ClmDiagnosisCode_3 VARCHAR(10),
    ClmDiagnosisCode_4 VARCHAR(10),
    ClmDiagnosisCode_5 VARCHAR(10),
    ClmDiagnosisCode_6 VARCHAR(10),
    ClmDiagnosisCode_7 VARCHAR(10),
    ClmDiagnosisCode_8 VARCHAR(10),
    ClmDiagnosisCode_9 VARCHAR(10),
    ClmDiagnosisCode_10 VARCHAR(10),
    ClmProcedureCode_1 VARCHAR(10),
    ClmProcedureCode_2 VARCHAR(10),
    ClmProcedureCode_3 VARCHAR(10),
    ClmProcedureCode_4 VARCHAR(10),
    ClmProcedureCode_5 VARCHAR(10),
    ClmProcedureCode_6 VARCHAR(10),
    DeductibleAmtPaid DECIMAL(10,2),
    ClmAdmitDiagnosisCode VARCHAR(10),
    FOREIGN KEY (BeneID) REFERENCES beneficiary(BeneID),
    FOREIGN KEY (Provider) REFERENCES provider(Provider)
);

SHOW TABLES;

SHOW VARIABLES;
SHOW VARIABLES LIKE 'secure_file_priv';

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Train-1542865627584.csv'
INTO TABLE provider
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Train_Beneficiarydata-1542865627584.csv'
INTO TABLE beneficiary
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(BeneID, DOB, @DOD, Gender, Race, RenalDiseaseIndicator, State, County,
NoOfMonths_PartACov, NoOfMonths_PartBCov, ChronicCond_Alzheimer, ChronicCond_Heartfailure,
ChronicCond_KidneyDisease, ChronicCond_Cancer, ChronicCond_ObstrPulmonary, ChronicCond_Depression,
ChronicCond_Diabetes, ChronicCond_IschemicHeart, ChronicCond_Osteoporasis,
ChronicCond_rheumatoidarthritis, ChronicCond_stroke, IPAnnualReimbursementAmt,
IPAnnualDeductibleAmt, OPAnnualReimbursementAmt, OPAnnualDeductibleAmt)
SET DOD = NULLIF(@DOD, 'NA');

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Train_Inpatientdata-1542865627584.csv'
INTO TABLE inpatient
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(BeneID, ClaimID, ClaimStartDt, ClaimEndDt, Provider, InscClaimAmtReimbursed,
@AttendingPhysician, @OperatingPhysician, @OtherPhysician, @AdmissionDt, ClmAdmitDiagnosisCode,
@DeductibleAmtPaid, @DischargeDt, DiagnosisGroupCode,
ClmDiagnosisCode_1, @ClmDiagnosisCode_2, @ClmDiagnosisCode_3, @ClmDiagnosisCode_4, @ClmDiagnosisCode_5,
@ClmDiagnosisCode_6, @ClmDiagnosisCode_7, @ClmDiagnosisCode_8, @ClmDiagnosisCode_9, @ClmDiagnosisCode_10,
@ClmProcedureCode_1, @ClmProcedureCode_2, @ClmProcedureCode_3, @ClmProcedureCode_4, @ClmProcedureCode_5,
@ClmProcedureCode_6)
SET AttendingPhysician = NULLIF(@AttendingPhysician, 'NA'),
	DeductibleAmtPaid = NULLIF(@DeductibleAmtPaid, 'NA'),
    DischargeDt = NULLIF(@DischargeDt, 'NA'),
    AdmissionDt = NULLIF(@AdmissionDt, 'NA'),
    OperatingPhysician = NULLIF(@OperatingPhysician, 'NA'),
    OtherPhysician = NULLIF(@OtherPhysician, 'NA'),
    ClmDiagnosisCode_2 = NULLIF(@ClmDiagnosisCode_2, 'NA'),
    ClmDiagnosisCode_3 = NULLIF(@ClmDiagnosisCode_3, 'NA'),
    ClmDiagnosisCode_4 = NULLIF(@ClmDiagnosisCode_4, 'NA'),
    ClmDiagnosisCode_5 = NULLIF(@ClmDiagnosisCode_5, 'NA'),
    ClmDiagnosisCode_6 = NULLIF(@ClmDiagnosisCode_6, 'NA'),
    ClmDiagnosisCode_7 = NULLIF(@ClmDiagnosisCode_7, 'NA'),
    ClmDiagnosisCode_8 = NULLIF(@ClmDiagnosisCode_8, 'NA'),
    ClmDiagnosisCode_9 = NULLIF(@ClmDiagnosisCode_9, 'NA'),
    ClmDiagnosisCode_10 = NULLIF(@ClmDiagnosisCode_10, 'NA'),
    ClmProcedureCode_1 = NULLIF(@ClmProcedureCode_1, 'NA'),
    ClmProcedureCode_2 = NULLIF(@ClmProcedureCode_2, 'NA'),
    ClmProcedureCode_3 = NULLIF(@ClmProcedureCode_3, 'NA'),
    ClmProcedureCode_4 = NULLIF(@ClmProcedureCode_4, 'NA'),
    ClmProcedureCode_5 = NULLIF(@ClmProcedureCode_5, 'NA'),
    ClmProcedureCode_6 = NULLIF(@lmProcedureCode_6, 'NA');
    
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Train_Outpatientdata-1542865627584.csv'
INTO TABLE outpatient
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
( BeneID,
    ClaimID,
    ClaimStartDt,
    ClaimEndDt,
    Provider,
    InscClaimAmtReimbursed,
    @AttendingPhysician,
    @OperatingPhysician,
    @OtherPhysician,
    @ClmDiagnosisCode_1,
    @ClmDiagnosisCode_2,
    @ClmDiagnosisCode_3,
    @ClmDiagnosisCode_4,
    @ClmDiagnosisCode_5,
    @ClmDiagnosisCode_6,
    @ClmDiagnosisCode_7,
    @ClmDiagnosisCode_8,
    @ClmDiagnosisCode_9,
    @ClmDiagnosisCode_10,
    @ClmProcedureCode_1,
    @ClmProcedureCode_2,
    @ClmProcedureCode_3,
    @ClmProcedureCode_4,
    @ClmProcedureCode_5,
    @ClmProcedureCode_6,
    @DeductibleAmtPaid,
    @ClmAdmitDiagnosisCode)
SET AttendingPhysician = NULLIF(@AttendingPhysician, 'NA'),
    OperatingPhysician = NULLIF(@OperatingPhysician, 'NA'),
    OtherPhysician = NULLIF(@OtherPhysician, 'NA'),
    ClmDiagnosisCode_1 = NULLIF(@ClmDiagnosisCode_1, 'NA'),
    ClmDiagnosisCode_2 = NULLIF(@ClmDiagnosisCode_2, 'NA'),
    ClmDiagnosisCode_3 = NULLIF(@ClmDiagnosisCode_3, 'NA'),
    ClmDiagnosisCode_4 = NULLIF(@ClmDiagnosisCode_4, 'NA'),
    ClmDiagnosisCode_5 = NULLIF(@ClmDiagnosisCode_5, 'NA'),
    ClmDiagnosisCode_6 = NULLIF(@ClmDiagnosisCode_6, 'NA'),
    ClmDiagnosisCode_7 = NULLIF(@ClmDiagnosisCode_7, 'NA'),
    ClmDiagnosisCode_8 = NULLIF(@ClmDiagnosisCode_8, 'NA'),
    ClmDiagnosisCode_9 = NULLIF(@ClmDiagnosisCode_9, 'NA'),
    ClmDiagnosisCode_10 = NULLIF(@ClmDiagnosisCode_10, 'NA'),
    ClmProcedureCode_1 = NULLIF(@ClmProcedureCode_1, 'NA'),
    ClmProcedureCode_2 = NULLIF(@ClmProcedureCode_2, 'NA'),
    ClmProcedureCode_3 = NULLIF(@ClmProcedureCode_3, 'NA'),
    ClmProcedureCode_4 = NULLIF(@ClmProcedureCode_4, 'NA'),
    ClmProcedureCode_5 = NULLIF(@ClmProcedureCode_5, 'NA'),
    ClmProcedureCode_6 = NULLIF(@ClmProcedureCode_6, 'NA'),
	DeductibleAmtPaid = NULLIF(@DeductibleAmtPaid, 'NA'),
    ClmAdmitDiagnosisCode = NULLIF(@ClmAdmitDiagnosisCode, 'NA');


SELECT 'BENEFICIARY' AS TABLENAME, COUNT(*) AS ROWSCOUNT FROM beneficiary
UNION ALL 
SELECT 'PROVIDER', COUNT(*) FROM provider
UNION ALL 
SELECT 'INPATIENT', COUNT(*) FROM inpatient
UNION ALL 
SELECT 'OUTPATIENT', COUNT(*) FROM outpatient;

