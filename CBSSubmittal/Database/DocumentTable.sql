USE [CBSSubmittal]
GO

/****** Object:  Table [dbo].[Document]    Script Date: 4/1/2020 9:16:10 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Document](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProjectId] [int] NOT NULL,
	[DocumentName] [nvarchar](150) NULL,
	[DocumentFile] [nvarchar](250) NOT NULL,
	[Details] [nvarchar](max) NULL,
	[Ordering] [int] NOT NULL,
	[UploadedBy] [int] NOT NULL,
	[UploadedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_Document] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[Document] ADD  CONSTRAINT [DF_Document_Ordering]  DEFAULT ((0)) FOR [Ordering]
GO

ALTER TABLE [dbo].[Document] ADD  CONSTRAINT [DF_Document_UploadedBy]  DEFAULT ((0)) FOR [UploadedBy]
GO

ALTER TABLE [dbo].[Document] ADD  CONSTRAINT [DF_Document_UploadedOn]  DEFAULT (getdate()) FOR [UploadedOn]
GO


