USE [CBSSubmittal]
GO
/****** Object:  StoredProcedure [dbo].[spCreateUser]    Script Date: 4/17/2020 1:30:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [dbo].[spCreateUser] 
	@FullName NVARCHAR(150)
	,@UserName NVARCHAR(100)
	,@Password NVARCHAR(200)
	,@Email NVARCHAR(200)
	,@RoleId INT
AS
BEGIN
DECLARE @Count INT
DECLARE @ReturnCode INT

SELECT @Count = COUNT(UserName)
FROM [User]
WHERE UserName = @UserName

IF @Count > 0
BEGIN
SET @ReturnCode = - 1
END
ELSE
BEGIN
SET @ReturnCode = 1

INSERT INTO [User]
VALUES (
@FullName
,@UserName
,@Password
,@Email
,@RoleId
)
END

SELECT @ReturnCode AS ReturnValue
END 