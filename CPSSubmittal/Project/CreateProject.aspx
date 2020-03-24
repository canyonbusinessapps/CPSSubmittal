<%@ Page Title="Projects" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CreateProject.aspx.cs" Inherits="CPSSubmittal.Project.CreateProject" Debug="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Content Header (Page header) -->
    <div class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1 class="m-0 text-dark">Projects</h1>
                </div>
                <!-- /.col -->
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right">
                        <li class="breadcrumb-item"><a href="~/" runat="server">Home</a></li>
                        <li class="breadcrumb-item active">Projects</li>
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
                    <h3 class="card-title">Create Project</h3>
                </div>
                <!-- /.card-header -->
                <div class="card-body">
                    <div class="row">
                        <div class="col-lg-3 col-md-3 col-sm-3">
                            <asp:TextBox ID="txtProjectName" CssClass="form-control" placeholder="Project Name" runat="server"></asp:TextBox>
                        </div>
                        <div class="col-lg-3 col-md-3 col-sm-3">
                            <asp:TextBox ID="txtDetails" CssClass="form-control" placeholder="Details" runat="server"></asp:TextBox>
                        </div>
                        <div class="col-lg-3 col-md-3 col-sm-3">
                            <asp:DropDownList ID="txtStatus" CssClass="form-control" runat="server">
                                <asp:ListItem Value="Active"> Active </asp:ListItem>
                                <asp:ListItem Value="Inactive"> Inactive </asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="col-lg-3 col-md-3 col-sm-3">
                            <asp:Button ID="btnSaveProject" OnClick="btnCreate_Click" CssClass="btn btn-md btn-primary" runat="server" Text="Create" />
                        </div>
                    </div>
                </div>
                <!-- /.card-body -->
            </div>

            <div class="card">
                <div class="card-header">
                    <h3 class="card-title">Projects</h3>
                </div>
                <!-- /.card-header -->
                <div class="card-body">
                    <asp:GridView ID="grdProject" AutoGenerateColumns="false" runat="server" CssClass="table table-striped table-bordered" OnRowDeleting="GridView_RowDeleting" DataKeyNames="Id">
                        <Columns>
                            <asp:BoundField DataField="ProjectName" HeaderText="Project Name" />
                            <asp:BoundField DataField="Details" HeaderText="Details" />
                            <asp:BoundField DataField="Status" HeaderText="Status" />
                            <asp:TemplateField HeaderStyle-Width="20">
                                <ItemTemplate>
                                    <asp:Button ID="deletebtn" runat="server" CommandName="Delete" CssClass="btn btn-danger btn-xs"
                                        Text="&nbsp;&nbsp;x&nbsp;&nbsp;" OnClientClick="return confirm('Are you sure you want to delete this item?');"/>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
                <!-- /.card-body -->
            </div>
        </div>
    </section>
    <%--<asp:SqlDataSource ID="dbContext" runat="server" ConnectionString="<%$ ConnectionStrings:dbContext %>" SelectCommand="SELECT * FROM [Project]"></asp:SqlDataSource>--%>
</asp:Content>
