﻿CREATE TABLE [Tree].[CtCategory]
(
	[Id]									int						NOT NULL,
	[Name]									nvarchar(20)			NOT NULL
);
GO

ALTER TABLE [Tree].[CtCategory]
	ADD CONSTRAINT [pk_CtCategory]
	PRIMARY KEY CLUSTERED ([Id]);
GO

CREATE NONCLUSTERED INDEX [ix_CtCategory_Name]
	ON [Tree].[CtCategory] ([Name]);
GO
