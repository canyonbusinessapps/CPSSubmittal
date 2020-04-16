<%@ Page Title="Create User" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CreateUser.aspx.cs" Inherits="CBSSubmittal.Account.CreateUser" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Content Header (Page header) -->
    <div class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1 class="m-0 text-dark">User</h1>
                </div>
                <!-- /.col -->
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right">
                        <li class="breadcrumb-item"><a href="~/" runat="server">Home</a></li>
                        <li class="breadcrumb-item active">Create User</li>
                    </ol>
                </div>
                <!-- /.col -->
            </div>
            <!-- /.row -->
        </div>
        <!-- /.container-fluid -->
    </div>
    <!-- /.content-header -->
    <section class="content">
        <div class="container-fluid">
            <div class="card card-info">
                <div class="card-header">
                    <h3 class="card-title">Create User</h3>
                </div>
                <!-- /.card-header -->
                <div class="card-body">
                    <!-- form start -->
                    <div class="card-body">
                        <div class="form-group row">
                            <label for="FullName" class="col-sm-2 col-form-label">Name</label>
                            <div class="col-sm-10">
                                <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control" placeholder="Name"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidatorfullname" runat="server" ErrorMessage="Name required" Text="*" ControlToValidate="txtFullName" ForeColor="Red">
                                </asp:RequiredFieldValidator>
                            </div>
                        </div>
                        <div class="form-group row">
                            <label for="UserName" class="col-sm-2 col-form-label">User Name</label>
                            <div class="col-sm-10">
                                <asp:TextBox ID="txtUserName" runat="server" CssClass="form-control" placeholder="User Name"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidatorusername" runat="server" ErrorMessage="User Name required" Text="*" ControlToValidate="txtUserName" ForeColor="Red">
                                </asp:RequiredFieldValidator>
                            </div>
                        </div>
                        <div class="form-group row">
                            <label for="Password" class="col-sm-2 col-form-label">Password</label>
                            <div class="col-sm-10">
                                <asp:TextBox ID="txtPassword" TextMode="Password" runat="server" CssClass="form-control" placeholder="Password"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidatorPassword" runat="server" ErrorMessage="Password required" Text="*" ControlToValidate="txtPassword" ForeColor="Red">
                                </asp:RequiredFieldValidator>
                            </div>
                        </div>
                        <div class="form-group row">
                            <label for="ConfirmPassword" class="col-sm-2 col-form-label">Confirm Password</label>
                            <div class="col-sm-10">
                                <asp:TextBox ID="txtConfirmPassword" TextMode="Password" runat="server" CssClass="form-control" placeholder="Confirm Password"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidatorConfirmPassword" runat="server" ErrorMessage="Confirm Password required" Text="*"
                                    ControlToValidate="txtConfirmPassword" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                                <asp:CompareValidator ID="CompareValidatorPassword" runat="server" ErrorMessage="Password and Confirm Password must match"
                                    ControlToValidate="txtConfirmPassword" ForeColor="Red" ControlToCompare="txtPassword" Display="Dynamic" Type="String" Operator="Equal" Text="*">
                                </asp:CompareValidator>
                            </div>
                        </div>
                        <div class="form-group row">
                            <label for="Email" class="col-sm-2 col-form-label">Email</label>
                            <div class="col-sm-10">
                                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="Email"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidatorEmail" runat="server" ErrorMessage="Email required" Text="*" ControlToValidate="txtEmail" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                                <asp:RegularExpressionValidator ID="RegularExpressionValidatorEmail"
                                    runat="server" ErrorMessage="Invalid Email" ControlToValidate="txtEmail" ForeColor="Red" Display="Dynamic" Text="*" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*">
                                </asp:RegularExpressionValidator>
                            </div>
                        </div>
                        <div class="form-group row">
                            <label for="RoleId" class="col-sm-2 col-form-label">Role</label>
                            <div class="col-sm-10">
                                <asp:DropDownList ID="ddRoleId" runat="server" DataSourceID="SqlDataSourceddRole" data-placeholder="Select Role"
                                    DataTextField="RoleName" DataValueField="Id" CssClass="form-control">
                                </asp:DropDownList>
                                <asp:SqlDataSource ID="SqlDataSourceddRole" runat="server" ConnectionString="<%$ ConnectionStrings:dbContext %>"
                                    SelectCommand="SELECT Id, RoleName FROM [dbo].[Role] ORDER BY RoleName ASC"></asp:SqlDataSource>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidatorRole" runat="server" ErrorMessage="Role required" Text="*" ControlToValidate="ddRoleId" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                            </div>
                        </div>
                        <div class="form-group row">
                            <label class="col-sm-2 col-form-label">&nbsp;</label>
                            <div class="col-sm-10">
                                <asp:ValidationSummary ID="ValidationSummary1" ForeColor="Red" runat="server" />
                                <asp:Label CssClass="text-danger" ID="lblMessage" runat="server"></asp:Label>
                            </div>
                        </div>
                    </div>
                    <!-- /.card-body -->
                    <div class="card-footer">
                        <asp:Button ID="btnRegister" runat="server" Text="CREATE" OnClick="btnRegister_Click" CssClass="btn btn-info" />
                    </div>
                    <!-- /.card-footer -->
                </div>
                <!-- /.card-body -->
            </div>
        </div>
    </section>
</asp:Content>
