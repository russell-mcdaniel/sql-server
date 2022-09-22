﻿CREATE TABLE [Tree].[CtCategoryHierarchy]
(
	[AncestorId]							int						NOT NULL,
	[DescendantId]							int						NOT NULL,
	[Depth]									int						NOT NULL
);
GO

ALTER TABLE [Tree].[CtCategoryHierarchy]
	ADD CONSTRAINT [pk_CtCategoryHierarchy]
	PRIMARY KEY CLUSTERED ([AncestorId], [DescendantId]);
GO

ALTER TABLE [Tree].[CtCategoryHierarchy]
	ADD CONSTRAINT [fk_CtCategoryHierarchy_AncestorId_CtCategory]
	FOREIGN KEY ([AncestorId])
	REFERENCES [Tree].[CtCategory] ([Id]);
GO

ALTER TABLE [Tree].[CtCategoryHierarchy]
	ADD CONSTRAINT [fk_CtCategoryHierarchy_DescendantId_CtCategory]
	FOREIGN KEY ([DescendantId])
	REFERENCES [Tree].[CtCategory] ([Id]);
GO

CREATE NONCLUSTERED INDEX [ix_CtCategoryHierarchy_AncestorId]
	ON [Tree].[CtCategoryHierarchy] ([AncestorId]);
GO

CREATE NONCLUSTERED INDEX [ix_CtCategoryHierarchy_DescendantId]
	ON [Tree].[CtCategoryHierarchy] ([DescendantId]);
GO
