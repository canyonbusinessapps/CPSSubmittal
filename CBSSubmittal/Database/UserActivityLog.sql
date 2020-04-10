CREATE TABLE [dbo].[UserActivityLog](
    [name] [nvarchar](100) NULL,
    [logDate] [datetime] NULL,
    [pageName] [nvarchar](100) NULL,
    [Activity] [nvarchar](100) NULL,
    [UserIP] [nvarchar](100) NULL,
    [id] [bigint] IDENTITY(1,1) NOT NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[UserActivityLog] ADD  CONSTRAINT [DF_UserActivityLog_logDate]  DEFAULT (getdate()) FOR [logDate]
GO