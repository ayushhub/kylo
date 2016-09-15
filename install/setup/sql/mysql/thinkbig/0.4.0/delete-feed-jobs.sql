USE thinkbig;

DROP PROCEDURE IF EXISTS `delete_feed_jobs`;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `delete_feed_jobs`(in category varchar(255), in feed varchar(255))
BEGIN

DECLARE jobName VARCHAR(255) DEFAULT CONCAT(category,'.',feed);

-- Delete NiFi jobs and steps (BATCH_NIFI_JOB, BATCH_NIFI_STEP)
DELETE BATCH_NIFI_STEP
FROM BATCH_NIFI_STEP
 INNER JOIN BATCH_STEP_EXECUTION ON BATCH_NIFI_STEP.STEP_EXECUTION_ID = BATCH_STEP_EXECUTION.STEP_EXECUTION_ID
 INNER JOIN BATCH_JOB_EXECUTION ON BATCH_STEP_EXECUTION.JOB_EXECUTION_ID = BATCH_JOB_EXECUTION.JOB_EXECUTION_ID
 INNER JOIN BATCH_JOB_INSTANCE ON BATCH_JOB_INSTANCE.JOB_INSTANCE_ID = BATCH_JOB_EXECUTION.JOB_INSTANCE_ID
WHERE BATCH_JOB_INSTANCE.JOB_NAME = jobName;

DELETE BATCH_NIFI_JOB
FROM BATCH_NIFI_JOB
 INNER JOIN BATCH_JOB_EXECUTION ON BATCH_NIFI_JOB.JOB_EXECUTION_ID = BATCH_JOB_EXECUTION.JOB_EXECUTION_ID
 INNER JOIN BATCH_JOB_INSTANCE ON BATCH_JOB_EXECUTION.JOB_INSTANCE_ID = BATCH_JOB_INSTANCE.JOB_INSTANCE_ID
WHERE BATCH_JOB_INSTANCE.JOB_NAME = jobName;

-- Delete step execution context (BATCH_EXECUTION_CONTEXT_VALUES, BATCH_STEP_EXECUTION_CONTEXT, BATCH_STEP_EXECUTION_CTX_VALS)
DELETE BATCH_EXECUTION_CONTEXT_VALUES
FROM BATCH_EXECUTION_CONTEXT_VALUES
 INNER JOIN BATCH_STEP_EXECUTION ON BATCH_EXECUTION_CONTEXT_VALUES.STEP_EXECUTION_ID = BATCH_STEP_EXECUTION.STEP_EXECUTION_ID
 INNER JOIN BATCH_JOB_EXECUTION ON BATCH_STEP_EXECUTION.JOB_EXECUTION_ID = BATCH_JOB_EXECUTION.JOB_EXECUTION_ID
 INNER JOIN BATCH_JOB_INSTANCE ON BATCH_JOB_EXECUTION.JOB_INSTANCE_ID = BATCH_JOB_INSTANCE.JOB_INSTANCE_ID
WHERE BATCH_JOB_INSTANCE.JOB_NAME = jobName;

DELETE BATCH_STEP_EXECUTION_CTX_VALS
FROM BATCH_STEP_EXECUTION_CTX_VALS
 INNER JOIN BATCH_STEP_EXECUTION ON BATCH_STEP_EXECUTION_CTX_VALS.STEP_EXECUTION_ID = BATCH_STEP_EXECUTION.STEP_EXECUTION_ID
 INNER JOIN BATCH_JOB_EXECUTION ON BATCH_STEP_EXECUTION.JOB_EXECUTION_ID = BATCH_JOB_EXECUTION.JOB_EXECUTION_ID
 INNER JOIN BATCH_JOB_INSTANCE ON BATCH_JOB_EXECUTION.JOB_INSTANCE_ID = BATCH_JOB_INSTANCE.JOB_INSTANCE_ID
WHERE BATCH_JOB_INSTANCE.JOB_NAME = jobName;

DELETE BATCH_STEP_EXECUTION_CONTEXT
FROM BATCH_STEP_EXECUTION_CONTEXT
 INNER JOIN BATCH_STEP_EXECUTION ON BATCH_STEP_EXECUTION_CONTEXT.STEP_EXECUTION_ID = BATCH_STEP_EXECUTION.STEP_EXECUTION_ID
 INNER JOIN BATCH_JOB_EXECUTION ON BATCH_STEP_EXECUTION.JOB_EXECUTION_ID = BATCH_JOB_EXECUTION.JOB_EXECUTION_ID
 INNER JOIN BATCH_JOB_INSTANCE ON BATCH_JOB_EXECUTION.JOB_INSTANCE_ID = BATCH_JOB_INSTANCE.JOB_INSTANCE_ID
WHERE BATCH_JOB_INSTANCE.JOB_NAME = jobName;

 -- Delete step executions (BATCH_STEP_EXECUTION)
DELETE BATCH_STEP_EXECUTION
FROM BATCH_STEP_EXECUTION
 INNER JOIN BATCH_JOB_EXECUTION ON BATCH_STEP_EXECUTION.JOB_EXECUTION_ID = BATCH_JOB_EXECUTION.JOB_EXECUTION_ID
 INNER JOIN BATCH_JOB_INSTANCE ON BATCH_JOB_EXECUTION.JOB_INSTANCE_ID = BATCH_JOB_INSTANCE.JOB_INSTANCE_ID
WHERE BATCH_JOB_INSTANCE.JOB_NAME = jobName;

-- Delete job execution context (BATCH_JOB_EXECUTION_CONTEXT, BATCH_JOB_EXECUTION_CTX_VALS)
DELETE BATCH_JOB_EXECUTION_CTX_VALS
FROM BATCH_JOB_EXECUTION_CTX_VALS
 INNER JOIN BATCH_JOB_EXECUTION ON BATCH_JOB_EXECUTION_CTX_VALS.JOB_EXECUTION_ID = BATCH_JOB_EXECUTION.JOB_EXECUTION_ID
 INNER JOIN BATCH_JOB_INSTANCE ON BATCH_JOB_EXECUTION.JOB_INSTANCE_ID = BATCH_JOB_INSTANCE.JOB_INSTANCE_ID
WHERE BATCH_JOB_INSTANCE.JOB_NAME = jobName;

DELETE BATCH_JOB_EXECUTION_CONTEXT
FROM BATCH_JOB_EXECUTION_CONTEXT
 INNER JOIN BATCH_JOB_EXECUTION ON BATCH_JOB_EXECUTION_CONTEXT.JOB_EXECUTION_ID = BATCH_JOB_EXECUTION.JOB_EXECUTION_ID
 INNER JOIN BATCH_JOB_INSTANCE ON BATCH_JOB_EXECUTION.JOB_INSTANCE_ID = BATCH_JOB_INSTANCE.JOB_INSTANCE_ID
WHERE BATCH_JOB_INSTANCE.JOB_NAME = jobName;

-- Delete job executions (BATCH_JOB_EXECUTION, BATCH_JOB_EXECUTION_PARAMS)
DELETE BATCH_JOB_EXECUTION_PARAMS
FROM BATCH_JOB_EXECUTION_PARAMS
 INNER JOIN BATCH_JOB_EXECUTION ON BATCH_JOB_EXECUTION_PARAMS.JOB_EXECUTION_ID = BATCH_JOB_EXECUTION.JOB_EXECUTION_ID
 INNER JOIN BATCH_JOB_INSTANCE ON BATCH_JOB_EXECUTION.JOB_INSTANCE_ID = BATCH_JOB_INSTANCE.JOB_INSTANCE_ID
WHERE BATCH_JOB_INSTANCE.JOB_NAME = jobName;

DELETE BATCH_JOB_EXECUTION
FROM BATCH_JOB_EXECUTION
INNER JOIN BATCH_JOB_INSTANCE ON BATCH_JOB_EXECUTION.JOB_INSTANCE_ID = BATCH_JOB_INSTANCE.JOB_INSTANCE_ID
WHERE BATCH_JOB_INSTANCE.JOB_NAME = jobName;

-- Delete job instance (BATCH_JOB_INSTANCE)
DELETE FROM BATCH_JOB_INSTANCE
WHERE BATCH_JOB_INSTANCE.JOB_NAME = jobName;

-- Delete NiFi stats
DELETE NIFI_RELATED_ROOT_FLOW_FILES
FROM NIFI_RELATED_ROOT_FLOW_FILES
 INNER JOIN NIFI_EVENT ON NIFI_RELATED_ROOT_FLOW_FILES.FLOW_FILE_ID = NIFI_EVENT.FLOW_FILE_ID OR NIFI_RELATED_ROOT_FLOW_FILES.EVENT_FLOW_FILE_ID = NIFI_EVENT.FLOW_FILE_ID
WHERE FM_FEED_NAME = jobName;

DELETE FROM NIFI_EVENT
WHERE FM_FEED_NAME = jobName;

DELETE FROM NIFI_FEED_PROCESSOR_STATS
WHERE FM_FEED_NAME = jobName;

END$$
DELIMITER ;
