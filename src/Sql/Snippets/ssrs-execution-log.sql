--
-- Depends on dbo.GetKeyValue UDF in Utilities folder.
--
use ReportServer;
GO

select
	e.TimeStart															as TimeStart,
	e.TimeEnd															as TimeEnd,
	datediff(millisecond, e.TimeStart, e.TimeEnd)						as TimeElapsed,
	e.ItemPath															as ItemPath,
	e.[RowCount]														as [RowCount],
	e.TimeDataRetrieval													as TimeDataRetrieval,
	e.TimeProcessing													as TimeProcessing,
	e.TimeRendering														as TimeRendering,
	e.TimeDataRetrieval + e.TimeProcessing + e.TimeRendering			as TimeTotal,
	e.ItemAction														as ItemAction,
	e.RequestType														as RequestType,
	e.Format															as Format,
	e.Source															as Source,
	e.Status															as Status,
	dbo.GetKeyValue(e.Parameters, N'ServerName', default, default)		as ServerName,
	dbo.GetKeyValue(e.Parameters, N'DatabaseName', default, default)	as DatabaseName,
	e.Parameters														as Parameters
from
	dbo.ExecutionLog3 e (nolock)
where
--	e.ItemPath = N'/Reports/ReportName'
--and
	e.TimeStart > dateadd(day, -1, getdate())				-- Last n days.
--and
--	dbo.GetKeyValue(e.Parameters, N'DatabaseName', default, default) = 'Demo'
order by
	e.TimeStart desc;
GO

/*
select
	c.ItemID,
	c.Path,
	c.Name,
	c.ParentID,
	c.Type,
	c.Intermediate,
	c.CreationDate,
	c.CreatedByID,
	c.ModifiedDate,
	c.ModifiedByID
from
	dbo.Catalog c (nolock)
order by
	c.Name;
GO
*/
