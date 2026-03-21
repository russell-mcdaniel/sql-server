USE [Database];
GO

-- Row group count by state.
SELECT
	s.state_desc							AS state_desc,
	COUNT(*)								AS group_count
FROM
	sys.dm_db_column_store_row_group_physical_stats s
GROUP BY
	s.state_desc
ORDER BY
	s.state_desc;
GO

-- Row group count by trim reason.
SELECT
	s.trim_reason_desc						AS trim_reason_desc,
	COUNT(*)								AS group_count
FROM
	sys.dm_db_column_store_row_group_physical_stats s
GROUP BY
	s.trim_reason_desc
ORDER BY
	s.trim_reason_desc;
GO

-- Row group count by transition reason.
SELECT
	s.transition_to_compressed_state_desc	AS transition_to_compressed_state_desc,
	COUNT(*)								AS group_count
FROM
	sys.dm_db_column_store_row_group_physical_stats s
GROUP BY
	s.transition_to_compressed_state_desc
ORDER BY
	s.transition_to_compressed_state_desc;
GO

/*
-- Row group details.
SELECT
	object_schema_name(s.object_id)		AS schema_name,
	object_name(s.object_id)			AS table_name,
	i.name								AS index_name,
	s.*
FROM
	sys.dm_db_column_store_row_group_physical_stats s
INNER JOIN
	sys.indexes i
ON
	i.object_id = s.object_id
AND
	i.index_id = s.index_id
ORDER BY
	s.object_id,
	s.index_id,
	s.row_group_id;
GO

-- Reorganize index.
ALTER INDEX cs_TableName
	ON dbo.TableName
	REORGANIZE;
GO
*/
