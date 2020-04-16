<%@ Page Title="Users" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Users.aspx.cs" Inherits="CBSSubmittal.Account.Users" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Content Header (Page header) -->
    <div class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1 class="m-0 text-dark">Users</h1>
                </div>
                <!-- /.col -->
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right">
                        <li class="breadcrumb-item"><a href="~/" runat="server">Home</a></li>
                        <li class="breadcrumb-item active">Users</li>
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
            <div class="card">
                <div class="card-header">
                    <h3 class="card-title">Users</h3>
                    <div class="card-tools" runat="server" id="theDiv">
                        <a href="<%=ResolveUrl("~/Account/CreateUser.aspx") %>" class="btn btn-primary btn-md"><i class="fa fa-plus"></i>CREATE USER</a>
                    </div>
                </div>
                <!-- /.card-header -->
                <div class="card-body">
                    <asp:GridView ID="usrGridView" runat="server" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="Id" DataSourceID="SqlDataSourceUsers" CssClass="table table-striped table-bordered">
                        <Columns>
                            <asp:BoundField DataField="Id" HeaderText="Id" InsertVisible="False" ReadOnly="True" SortExpression="Id" Visible="false" />
                            <asp:BoundField DataField="FullName" HeaderText="Name" SortExpression="FullName" />
                            <asp:BoundField DataField="UserName" HeaderText="User Name" SortExpression="UserName" />
                            <asp:BoundField DataField="Email" HeaderText="Email" SortExpression="Email" />
                            <asp:TemplateField HeaderText="Role" SortExpression="RoleName">
                                <EditItemTemplate>
                                    <asp:DropDownList ID="RoleName" runat="server" DataSourceID="SqlDataSourceddRole" data-placeholder="Select Role" DataTextField="RoleName" DataValueField="Id" SelectedValue='<%# Bind("RoleId")%>'  CssClass="form-control"></asp:DropDownList>
                                    <asp:SqlDataSource ID="SqlDataSourceddRole" runat="server" ConnectionString="<%$ ConnectionStrings:dbContext %>" SelectCommand="SELECT Id, RoleName FROM [dbo].[Role] ORDER BY RoleName ASC">
                                    </asp:SqlDataSource>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lblRoleId" runat="server" Text='<%# Bind("RoleName") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField ShowHeader="False">
                                <EditItemTemplate>
                                    <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="True" CommandName="Update" Text="Update" CssClass="btn btn-primary btn-xs"><i class="fa fa-save" aria-hidden="true"></i></asp:LinkButton>
                                    &nbsp;<asp:LinkButton ID="LinkButton2" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancel" CssClass="btn btn-warning btn-xs"><i class="fa fa-times" aria-hidden="true"></i></asp:LinkButton>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="False" CommandName="Edit" Text="Edit" CssClass="btn btn-primary btn-xs"><i class="fa fa-edit" aria-hidden="true"></i></asp:LinkButton>
                                    &nbsp;<asp:LinkButton ID="LinkButton2" runat="server" OnClientClick="return confirm('Are you sure you want to delete this item?');" CausesValidation="False" CommandName="Delete" Text="Delete" CssClass="btn btn-danger btn-xs"><i class="fa fa-trash" aria-hidden="true"></i>
                                    </asp:LinkButton>
                                    <a id="ChangePasswordLink" class="btn btn-warning btn-xs" title="Change Password" href="ChangePassword.aspx?Id=<%#Eval("Id") %>">
                                        <i class="fas fa-lock"></i>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                    <asp:SqlDataSource ID="SqlDataSourceUsers" runat="server" ConnectionString="<%$ ConnectionStrings:dbContext %>" DeleteCommand="DELETE FROM [User] WHERE [Id] = @Id" InsertCommand="INSERT INTO [User] ([FullName], [UserName], [Password], [Email], [RoleId]) VALUES (@FullName, @UserName, @Password, @Email, @RoleId)" SelectCommand="SELECT U.Id, U.FullName, U.UserName, U.Email, R.RoleName AS RoleName, R.Id AS RoleId FROM [User] U LEFT JOIN [Role] R ON R.Id=U.RoleId" UpdateCommand="UPDATE [User] SET [FullName] = @FullName,  [UserName] = @UserName, [Email] = @Email, [RoleId] = @RoleId WHERE [Id] = @Id">
                        <DeleteParameters>
                            <asp:Parameter Name="Id" Type="Int32" />
                        </DeleteParameters>
                        <InsertParameters>
                            <asp:Parameter Name="FullName" Type="String" />
                            <asp:Parameter Name="UserName" Type="String" />
                            <asp:Parameter Name="Password" Type="String" />
                            <asp:Parameter Name="Email" Type="String" />
                            <asp:Parameter Name="RoleId" Type="Int32" />
                        </InsertParameters>
                        <UpdateParameters>
                            <asp:Parameter Name="FullName" Type="String" />
                            <asp:Parameter Name="UserName" Type="String" />
                            <asp:Parameter Name="Password" Type="String" />
                            <asp:Parameter Name="Email" Type="String" />
                            <asp:Parameter Name="RoleId" Type="Int32" />
                            <asp:Parameter Name="Id" Type="Int32" /> 
                        </UpdateParameters>
                    </asp:SqlDataSource>
                </div>
                <!-- /.card-body -->
            </div>
        </div>
    </section>
</asp:Content>
