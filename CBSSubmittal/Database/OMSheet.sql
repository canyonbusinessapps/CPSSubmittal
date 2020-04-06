USE [CBSSubmittal]
GO

/****** Object:  Table [dbo].[OMSheet]    Script Date: 4/6/2020 9:18:52 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[OMSheet](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DocumentName] [nvarchar](150) NULL,
	[DocumentFile] [nvarchar](250) NOT NULL,
	[Details] [nvarchar](max) NULL,
	[Ordering] [int] NOT NULL,
	[UploadedBy] [int] NOT NULL,
	[UploadedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_OMSheet] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[OMSheet] ADD  CONSTRAINT [DF_OMSheet_Ordering]  DEFAULT ((0)) FOR [Ordering]
GO

ALTER TABLE [dbo].[OMSheet] ADD  CONSTRAINT [DF_OMSheet_UploadedBy]  DEFAULT ((0)) FOR [UploadedBy]
GO

ALTER TABLE [dbo].[OMSheet] ADD  CONSTRAINT [DF_OMSheet_UploadedOn]  DEFAULT (getdate()) FOR [UploadedOn]
GO


