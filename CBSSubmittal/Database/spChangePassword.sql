Create Proc spChangePassword
@Id int,
@Password nvarchar(100)
as
Begin
 
 if(@Id is null)
	 Begin
	  -- If Id does not exist
	  Select 0 as IsPasswordChanged
	 End
 Else
	 Begin
	  -- If UserId exists, Update with new password
	  Update [User] set
	  [Password] = @Password
	  where Id = @Id
	  -- If Id exist
	  Select 1 as IsPasswordChanged
	 End
End