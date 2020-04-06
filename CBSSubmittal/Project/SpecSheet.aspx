﻿<%@ Page Title="Spec Sheets" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="SpecSheet.aspx.cs" Inherits="CBSSubmittal.Project.SpecSheet" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Content Header (Page header) -->
    <div class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1 class="m-0 text-dark">Spec Sheets</h1>
                </div>
                <!-- /.col -->
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right">
                        <li class="breadcrumb-item"><a href="~/" runat="server">Home</a></li>
                        <li class="breadcrumb-item active">Spec Sheets</li>
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
                    <h3 class="card-title">Upload Spec Sheet</h3>
                </div>
                <!-- /.card-header -->
                <div class="card-body">
                    <div class="row">
                        <div class="col-lg-3 col-md-3 col-sm-3">
                            <asp:TextBox ID="txtDocumentName" CssClass="form-control" placeholder="Sheet Name" runat="server"></asp:TextBox>
                        </div>
                        <div class="col-lg-3 col-md-3 col-sm-3">
                            <div class="form-group">
                                <div class="custom-file">
                                    <asp:FileUpload ID="fileDocumentFile" CssClass="custom-file-input" runat="server" />
                                    <label class="custom-file-label" for="customFile">Choose file</label>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-4 col-md-4 col-sm-4" style="display:none;">
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
                    <h3 class="card-title">Spec Sheets</h3>
                </div>
                <!-- /.card-header -->
                <div class="card-body">
                    <asp:GridView ID="grdDocument" AutoGenerateColumns="false" runat="server" CssClass="table table-striped table-bordered" OnRowDeleting="GridView_RowDeleting" DataKeyNames="Id">
                        <Columns>
                            <asp:BoundField DataField="DocumentName" HeaderText="Sheet Name" />
                            <asp:BoundField DataField="DocumentFile" HeaderText="File" SortExpression="DocumentFile" />
                            <%--<asp:BoundField DataField="Details" HeaderText="Details" />--%>
                            <asp:TemplateField HeaderStyle-Width="20">
                                <ItemTemplate>
                                    <a id="downloadLink" class="btn btn-info btn-xs" title="Downlaod" href="SpecSheet.aspx?Id=<%#Eval("Id") %>">
                                        <i class="fas fa-download"></i>
                                    </a>
                                    <asp:Button ID="deletebtn" runat="server" CommandName="Delete" CssClass="btn btn-danger btn-xs"
                                        Text="&nbsp;&nbsp;X&nbsp;&nbsp;" OnClientClick="return confirm('Are you sure you want to delete this item?');" />
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