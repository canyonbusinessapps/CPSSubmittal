<%@ Page Title="Change Password" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ChangePasswordUser.aspx.cs" Inherits="CBSSubmittal.Account.ChangePasswordUser" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Content Header (Page header) -->
    <div class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1 class="m-0 text-dark"><% Response.Write(Session["FullName"].ToString()); %></h1>
                </div>
                <!-- /.col -->
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right">
                        <li class="breadcrumb-item"><a href="~/" runat="server">Home</a></li>
                        <li class="breadcrumb-item active">Change Password</li>
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
            <div class="card card-warning">
                <div class="card-header">
                    <h3 class="card-title">Change Password</h3>
                </div>
                <!-- /.card-header -->
                <div class="card-body">
                    <div class="form-group row">
                        <label for="Password" class="col-sm-2 col-form-label">Current Password</label>
                        <div class="col-sm-10">
                            <asp:TextBox ID="txtCurrentPassword" TextMode="Password" runat="server" CssClass="form-control" placeholder="Current Password"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorCurrentPassword" runat="server" ErrorMessage="Current Password required" Text="*" ControlToValidate="txtCurrentPassword" ForeColor="Red">
                            </asp:RequiredFieldValidator>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label for="Password" class="col-sm-2 col-form-label">New Password</label>
                        <div class="col-sm-10">
                            <asp:TextBox ID="txtNewPassword" TextMode="Password" runat="server" CssClass="form-control" placeholder="New Password"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorNewPassword" runat="server" ErrorMessage="New Password required" Text="*"
                                ControlToValidate="txtNewPassword" ForeColor="Red">
                            </asp:RequiredFieldValidator>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label for="ConfirmPassword" class="col-sm-2 col-form-label">Confirm New Password</label>
                        <div class="col-sm-10">
                            <asp:TextBox ID="txtConfirmNewPassword" TextMode="Password" runat="server" CssClass="form-control" placeholder="Confirm New Password">
                            </asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorConfirmNewPassword" runat="server" ErrorMessage="Confirm New Password required" Text="*"
                                ControlToValidate="txtConfirmNewPassword" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                            <asp:CompareValidator ID="CompareValidatorPassword" runat="server" ErrorMessage="New Password and Confirm New Password must match"
                                ControlToValidate="txtConfirmNewPassword" ForeColor="Red" ControlToCompare="txtNewPassword" Display="Dynamic" Type="String" Operator="Equal" Text="*">
                            </asp:CompareValidator>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label">&nbsp;</label>
                        <div class="col-sm-10">
                            <asp:ValidationSummary ID="ValidationSummary1" ForeColor="Red" runat="server" />
                            <asp:Label CssClass="text-danger" ID="lblMessage" runat="server"></asp:Label>
                        </div>
                    </div>
                    <div class="card-footer">
                        <asp:Button ID="btnSave" runat="server" Text="CHANGE PASSWORD" OnClick="btnSave_Click" CssClass="btn btn-info" />
                    </div>
                </div>
                <!-- /.card-body -->
            </div>
        </div>
    </section>
</asp:Content>
