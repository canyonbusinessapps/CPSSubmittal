USE [CBSSubmittal]
GO
/****** Object:  StoredProcedure [dbo].[spAuthenticateUser]    Script Date: 4/3/2020 11:16:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spAuthenticateUser]
@UserName nvarchar(100)
,@Password nvarchar(100)
as
Begin
 Declare @Count int
 
 Select @Count = COUNT(UserName) from [User]
 where [UserName] = @UserName and [Password] = @Password
 
 if(@Count = 1)
 Begin
  Select 1 as ReturnCode
 End
 Else
 Begin
  Select -1 as ReturnCode
 End
End