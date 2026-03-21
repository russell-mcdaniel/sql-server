use master;
GO

select
	d.database_id							as database_id,
	d.name									as database_name,
	f.file_id								as file_id,
	f.type									as type,
	f.type_desc								as type_desc,
	f.name									as logical_file_name,
	f.physical_name							as physical_file_name,
	f.growth,
	f.is_percent_growth,
	f.size									as size_pages,
	f.size * cast(8 as bigint)				as size_kb,
	cast(f.size / 128.0 as decimal(9,1))	as size_mb,
	'use [' + d.name + ']; dbcc shrinkfile([' + f.name + '], 256);'
											as shrink_sql
from
	sys.databases d
inner join
	sys.master_files f
on
	f.database_id = d.database_id
where
	f.type_desc = N'LOG'
order by
	f.size desc,
	d.name;
GO
