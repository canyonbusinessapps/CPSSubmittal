USE [CBSSubmittal]
GO
/****** Object:  StoredProcedure [dbo].[spChangePasswordUsingCurrentPassword]    Script Date: 4/17/2020 2:21:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Proc [dbo].[spChangePasswordUsingCurrentPassword]
@UserName nvarchar(100),
@CurrentPassword nvarchar(100),
@NewPassword nvarchar(100)
as
Begin
 if(Exists(Select Id from [User] 
    where UserName = @UserName
    and [Password] = @CurrentPassword))
 Begin
  Update [User]
  Set [Password] = @NewPassword
  where UserName = @UserName
  
  Select 1 as IsPasswordChanged
 End
 Else
 Begin
  Select 0 as IsPasswordChanged
 End
End