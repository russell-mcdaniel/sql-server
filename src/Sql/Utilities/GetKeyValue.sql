-- ================================================================================
-- Extract values from query string-style strings with key-value pairs.
--
-- Reference
-- https://dba.stackexchange.com/questions/249593/manipulating-a-column-containing-key-value-pairs
-- ================================================================================
IF EXISTS (SELECT * FROM sys.objects WHERE name = N'GetKeyValue' AND type = N'FN')
DROP FUNCTION dbo.GetKeyValue;
GO

CREATE FUNCTION dbo.GetKeyValue
(
	@Data				nvarchar(MAX),
	@Key				nvarchar(MAX),
	@KeyDelimiter		nchar(1)			= N'&',
	@ValueDelimiter		nchar(1)			= N'='
)
RETURNS nvarchar(MAX)
AS
BEGIN
	-- Ensure leading and trailing key delimiters so that the value extraction
	-- logic does not require a special case for the first and last keys.
	SET @Data = @KeyDelimiter + @Data + @KeyDelimiter;
	
	DECLARE @Value nvarchar(MAX) = NULL;

	-- Check that the key exists.
	IF (PATINDEX(N'%' + @KeyDelimiter + @Key + @ValueDelimiter + N'%', @Data) > 0)
	BEGIN
		-- Extract the key value.
		SET @Value = (SELECT
						SUBSTRING(
							@Data,
							CHARINDEX(@ValueDelimiter, @Data, PATINDEX(N'%' + @Key + N'%', @Data)) + 1,
							CHARINDEX(@KeyDelimiter, @Data, PATINDEX(N'%' + @Key + N'%', @Data)) - CHARINDEX(@ValueDelimiter, @Data, PATINDEX(N'%' + @Key + N'%', @Data)) - 1));

		-- Perform naive URL decoding for commonly encountered characters.
		SET @Value = REPLACE(
						REPLACE(
							REPLACE(
								@Value,
								N'%20',
								N' '),
							N'%2F',
							N'/'),
						N'%3A',
						N':');
	END;

	RETURN @Value;
END;
GO
