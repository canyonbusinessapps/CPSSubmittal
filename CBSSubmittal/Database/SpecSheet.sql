USE [CBSSubmittal]
GO

/****** Object:  Table [dbo].[SpecSheet]    Script Date: 4/6/2020 9:19:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SpecSheet](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DocumentName] [nvarchar](150) NULL,
	[DocumentFile] [nvarchar](250) NOT NULL,
	[Details] [nvarchar](max) NULL,
	[Ordering] [int] NOT NULL,
	[UploadedBy] [int] NOT NULL,
	[UploadedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_SpecSheet] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[SpecSheet] ADD  CONSTRAINT [DF_SpecSheet_Ordering]  DEFAULT ((0)) FOR [Ordering]
GO

ALTER TABLE [dbo].[SpecSheet] ADD  CONSTRAINT [DF_SpecSheet_UploadedBy]  DEFAULT ((0)) FOR [UploadedBy]
GO

ALTER TABLE [dbo].[SpecSheet] ADD  CONSTRAINT [DF_SpecSheet_UploadedOn]  DEFAULT (getdate()) FOR [UploadedOn]
GO


