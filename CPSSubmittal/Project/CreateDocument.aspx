<%@ Page Title="Documents" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CreateDocument.aspx.cs" Inherits="CPSSubmittal.Project.CreateDocument" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Content Header (Page header) -->
    <div class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1 class="m-0 text-dark">Documents</h1>
                </div>
                <!-- /.col -->
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right">
                        <li class="breadcrumb-item"><a href="~/" runat="server">Home</a></li>
                        <li class="breadcrumb-item active">Documents</li>
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
                    <h3 class="card-title">Create Document</h3>
                </div>
                <!-- /.card-header -->
                <div class="card-body">
                    <div class="row">
                        <div class="col-lg-2 col-md-2 col-sm-2">
                            <asp:DropDownList ID="txtProjectId" runat="server" DataSourceID="SqlDataSourceUser" data-placeholder="Select Project"
                                DataTextField="ProjectName" DataValueField="Id" CssClass="form-control">
                            </asp:DropDownList>
                            <asp:SqlDataSource ID="SqlDataSourceUser" runat="server" ConnectionString="<%$ ConnectionStrings:dbContext %>"
                                SelectCommand="SELECT Id, ProjectName FROM [dbo].[Project] ORDER BY ProjectName ASC">
                            </asp:SqlDataSource>

                        </div>
                        <div class="col-lg-2 col-md-2 col-sm-2">
                            <asp:TextBox ID="txtDocumentName" CssClass="form-control" placeholder="Document Name" runat="server"></asp:TextBox>
                        </div>
                        <div class="col-lg-2 col-md-2 col-sm-2">
                            <div class="form-group">
                                <div class="custom-file">
                                    <asp:FileUpload ID="fileDocumentFile" CssClass="custom-file-input" runat="server" />
                                    <label class="custom-file-label" for="customFile">Choose file</label>
                                </div>
                            </div>                            
                        </div>
                        <div class="col-lg-4 col-md-4 col-sm-4">
                            <asp:TextBox ID="txtDetails" CssClass="form-control" placeholder="Details" runat="server"></asp:TextBox>
                        </div>
                        <div class="col-lg-2 col-md-2 col-sm-2">
                            <asp:Button ID="btnSaveDoocument" OnClick="btnCreate_Click" CssClass="btn btn-md btn-primary" runat="server" Text="Create" />
                        </div>
                    </div>
                </div>
                <!-- /.card-body -->
            </div>

            <div class="card">
                <div class="card-header">
                    <h3 class="card-title">Documents</h3>
                </div>
                <!-- /.card-header -->
                <div class="card-body">
                    <asp:GridView ID="grdDocument" AutoGenerateColumns="false" runat="server" CssClass="table table-striped table-bordered" OnRowDeleting="GridView_RowDeleting" DataKeyNames="Id">
                        <Columns>
                            <asp:BoundField DataField="ProjectName" HeaderText="Project Name" />
                            <asp:BoundField DataField="DocumentName" HeaderText="Document Name" />
                            <asp:BoundField DataField="Details" HeaderText="Details" />
                            <asp:TemplateField HeaderStyle-Width="20">
                                <ItemTemplate>
                                    <asp:Button ID="deletebtn" runat="server" CommandName="Delete" CssClass="btn btn-danger btn-xs"
                                        Text="&nbsp;&nbsp;x&nbsp;&nbsp;" OnClientClick="return confirm('Are you sure you want to delete this item?');" />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
                <!-- /.card-body -->
            </div>
        </div>
    </section>
</asp:Content>
