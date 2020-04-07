<%@ Page Title="Spec Sheets" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="SpecSheet.aspx.cs" Inherits="CBSSubmittal.Project.SpecSheet" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            $("#btnUpload").click(function (event) {
                var files = $("#<%=FileUpload1.ClientID%>").get(0).files;
                if (files.length > 0) {
                    var formData = new FormData();
                    for (var i = 0; i < files.length; i++) {
                        formData.append(files[i].name, files[i]);
                    }
                    $.ajax({
                        url: 'SpecSheetHandler.ashx',
                        method: 'post',
                        data: formData,
                        contentType: false,
                        processData: false,
                        success: function () {
                            $('#progressBar').show();
                            setTimeout(function () {
                                $("#progressBar").hide('blind', {}, 500)
                            }, 5000);
                            setInterval(function () {
                                location.reload(); 
                            }, 5000);
                        },
                        error: function (err) {
                            alert(err.statusText);
                        }
                    });
                }
            });
        });
    </script>
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
                        <div class="col-lg-4 col-md-4 col-sm-4">
                            <asp:FileUpload ID="FileUpload1" runat="server" AllowMultiple="true" />
                        </div>
                        <div class="col-lg-2 col-md-2 col-sm-2">
                            <input type="button" id="btnUpload" value="Upload Spec Sheets" class="btn btn-md btn-primary" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-8 col-md-8 col-sm-8">
                            <div id="progressBar" class="progress" style="margin-top: 20px; display: none;">
                                <div class="progress-bar progress-bar-striped progress-bar-animated bg-primary" role="progressbar" aria-valuenow="75" aria-valuemin="0" aria-valuemax="100" style="width: 75%"></div>
                            </div>
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
