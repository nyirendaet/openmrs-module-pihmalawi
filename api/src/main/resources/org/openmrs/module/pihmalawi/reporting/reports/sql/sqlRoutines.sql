-- Stored Procedures

-- getLastNumericObsBeforeDate(cid, endDate, tempTableName)
-- INPUTS: 		cid - observation concept id
--				endDate - end Date of report
-- 				tempTableName - temporary table to write to
-- Procedure provides a table of the last observation before end date for a cohort of patients.
-- Procedure assumes obs_datetime is relevant last date (may not be accurate for obs groups) and
-- that internal patient identifiers are supplied by the PID in the tempCohort table. 

DROP PROCEDURE IF EXISTS getLastNumericObsBeforeDate;

DELIMITER ;;
CREATE PROCEDURE getLastNumericObsBeforeDate(IN cid INT, IN endDate DATE, IN tempTableName VARCHAR(100))
BEGIN

	DROP TEMPORARY TABLE IF EXISTS temp_obs_vector;
	create temporary table temp_obs_vector (
  		id INT not null auto_increment primary key,
  		PID INT(11) not NULL,
  		obs NUMERIC
	);

	insert into temp_obs_vector
			(PID, obs)
	select  PID, value_numeric
	from tempCohort tt
	left join (select * from 
				(select * from obs 
				where concept_id = cid 
				and obs_datetime <= endDate 
				and voided = 0 
				order by obs_datetime desc) 
				oi group by person_id) o 
	on o.person_id = tt.PID
	where o.person_id = tt.PID; 

	SET @s=CONCAT('ALTER TABLE temp_obs_vector RENAME ', tempTableName,';');
	PREPARE stmt1 FROM @s;
	EXECUTE stmt1;
	DEALLOCATE PREPARE stmt1;

END;;
DELIMITER ;

-- getAllARVNumbers(cid, endDate, tempTableName)
-- INPUTS: 		endDate - end Date of report
--				tempTableName - temporary table to write to
-- Procedure provides a table of a concatenated list of patient ARV numbers before end date 
-- for a cohort of patients.
-- Procedure assumes date_created is relevant last date and that internal patient identifiers 
-- are supplied by the PID in the tempCohort table. 

DROP PROCEDURE IF EXISTS getAllARVNumbers;

DELIMITER ;;
CREATE PROCEDURE getAllARVNumbers(IN endDate DATE, IN tempTableName VARCHAR(100))
BEGIN

	DROP TEMPORARY TABLE IF EXISTS temp_obs_vector;
	create temporary table temp_obs_vector (
  		id INT not null auto_increment primary key,
  		PID INT(11) not NULL,
  		obs VARCHAR(100) default NULL 
	);

	insert into temp_obs_vector
			(PID, obs)
	select  patient_id, group_concat(pi.identifier separator ', ') as id_string
			from patient_identifier pi 
			join tempCohort tc on tc.PID = pi.patient_id
			where identifier_type = 4
			and voided = 0 
			and date_created <= endDate 
			group by patient_id;

	SET @s=CONCAT('ALTER TABLE temp_obs_vector RENAME ', tempTableName,';');
	PREPARE stmt1 FROM @s;
	EXECUTE stmt1;
	DEALLOCATE PREPARE stmt1;

END;;
DELIMITER ;