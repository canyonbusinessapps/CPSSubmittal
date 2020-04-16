<%@ Page Title="Documents" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CreateDocument.aspx.cs" Inherits="CBSSubmittal.Project.CreateDocument" %>

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
                        <div class="col-lg-3 col-md-3 col-sm-3">
                            <asp:TextBox ID="txtDocumentName" CssClass="form-control" placeholder="Document Name" runat="server"></asp:TextBox>
                        </div>
                        <div class="col-lg-3 col-md-3 col-sm-3">
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
                     <div class="row" style="margin-bottom: 10px;">
                        <div class="col-6">
                            <asp:TextBox ID="txtSearch" runat="server" placeholder="Search Text" CssClass="form-control"></asp:TextBox>
                        </div>
                        <div class="col-2">
                            <asp:Button ID="srcButton" runat="server" Text="Search" OnClick="srcButton_Click" CssClass="btn btn-md btn-primary" />
                        </div>
                    </div>
                    <asp:GridView ID="grdDocument" AutoGenerateColumns="false" runat="server" AllowPaging="True" PageSize="20" OnPageIndexChanging="grdDocument_PageIndexChanging" AllowSorting="True" OnRowEditing="grdDocument_RowEditing" OnRowCancelingEdit="grdDocument_RowCancelingEdit" OnRowUpdating="grdDocument_RowUpdating" OnRowDeleting="GridView_RowDeleting" DataKeyNames="Id" CssClass="table table-striped table-bordered">
                        <Columns>
                            <asp:TemplateField HeaderText="ID" Visible="false">
                                <ItemTemplate>
                                    <asp:Label ID="DocumentId" runat="server" Text='<%# Bind("Id") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Project" SortExpression="ProjectName">
                                <ItemTemplate>
                                    <asp:Label ID="lblProjectName" runat="server" Text='<%# Bind("ProjectName") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Title" SortExpression="DocumentName">
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtDocumentName" runat="server" Text='<%# Bind("DocumentName") %>' CssClass="form-control"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="reqDocumentNameEdit" runat="server" ValidationGroup="UPDATE"
                                        ErrorMessage="Document Name Name is required." ControlToValidate="txtDocumentName" Text="*" ForeColor="Red"></asp:RequiredFieldValidator>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lblDocumentName" runat="server" Text='<%# Bind("DocumentName") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Details" SortExpression="Details">
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtDetails" runat="server" Text='<%# Bind("Details") %>' CssClass="form-control"></asp:TextBox>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lblDetails" runat="server" Text='<%# Bind("Details") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderStyle-Width="20">
                                <ItemTemplate>
                                    <a id="downloadLink" class="btn btn-info btn-xs" title="Downlaod" href="CreateDocument.aspx?Id=<%#Eval("Id") %>">
                                        <i class="fas fa-download"></i>
                                    </a>
                                    <asp:Button ID="deletebtn" runat="server" CommandName="Delete" CssClass="btn btn-danger btn-xs"
                                        Text="&nbsp;&nbsp;X&nbsp;&nbsp;" OnClientClick="return confirm('Are you sure you want to delete this item?');" />
                                    <asp:Button ID="Button2" runat="server" CausesValidation="False" CommandName="Edit" Text="Edit" CssClass="btn btn-info btn-xs" />
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:Button ID="Button3" runat="server" CausesValidation="True" CommandName="Update" Text="Update" CssClass="btn btn-info btn-xs" />
                                    <asp:Button ID="Button4" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancel" CssClass="btn btn-warning btn-xs" />
                                </EditItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
                <!-- /.card-body -->
            </div>
        </div>
    </section>
</asp:Content>
