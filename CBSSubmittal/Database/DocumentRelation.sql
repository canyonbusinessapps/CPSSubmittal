USE [CBSSubmittal]
GO

/****** Object:  Table [dbo].[DocumentRelation]    Script Date: 4/9/2020 9:04:37 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DocumentRelation](
	[DocumentType] [nvarchar](10) NOT NULL,
	[ProjectId] [int] NOT NULL,
	[DocumentId] [int] NOT NULL,
	[Ordering] [int] NOT NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[DocumentRelation] ADD  CONSTRAINT [DF_DocumentRelation_Ordering]  DEFAULT ((0)) FOR [Ordering]
GO


