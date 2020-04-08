USE [CBSSubmittal]
GO

/****** Object:  Table [dbo].[DocumentRelation]    Script Date: 4/8/2020 11:11:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DocumentRelation](
	[DocumentType] [nvarchar](10) NOT NULL,
	[ProjectId] [int] NOT NULL,
	[DocumentId] [int] NOT NULL
) ON [PRIMARY]
GO


