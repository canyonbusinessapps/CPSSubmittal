<%@ Page Title="O&M Sheets" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="OMSheet.aspx.cs" Inherits="CBSSubmittal.Project.OMSheet" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            $("#btnUploadOMSheet").click(function (event) {
                var files = $("#<%=FileUploadOMSheet.ClientID%>").get(0).files;
                if (files.length > 0) {
                    var formData = new FormData();
                    for (var i = 0; i < files.length; i++) {
                        formData.append(files[i].name, files[i]);
                    }
                    $.ajax({
                        url: 'OMSheetHandler.ashx',
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
        function Selectallcheckbox(val) {
            if (!$(this).is(':checked')) {
                $('input:checkbox').prop('checked', val.checked);
            } else {
                $("#chkroot").removeAttr('checked');
            }
        }
    </script>
    <!-- Content Header (Page header) -->
    <div class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1 class="m-0 text-dark">O&M Sheets</h1>
                </div>
                <!-- /.col -->
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right">
                        <li class="breadcrumb-item"><a href="~/" runat="server">Home</a></li>
                        <li class="breadcrumb-item active">O&M Sheets</li>
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
                    <h3 class="card-title">Upload O&M Sheet</h3>
                </div>
                <!-- /.card-header -->
                <div class="card-body">
                    <div class="row">
                        <div class="col-lg-4 col-md-4 col-sm-4">
                            <asp:FileUpload ID="FileUploadOMSheet" runat="server" AllowMultiple="true" />
                        </div>
                        <div class="col-lg-2 col-md-2 col-sm-2">
                            <input type="button" id="btnUploadOMSheet" value="Upload O&M Sheets" class="btn btn-md btn-primary" />
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
                    <h3 class="card-title">O&M Sheets</h3>
                </div>
                <!-- /.card-header -->
                <div class="card-body">
                    <div style="margin-bottom: 10px;">
                        <asp:Button ID="Button1" runat="server" OnClick="Button1_Click" Text="Attach with this project " CssClass="btn btn-md btn-primary" />
                    </div>
                    <asp:GridView ID="grdDocument" runat="server" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="Id" CssClass="table table-striped table-bordered" DataSourceID="SqlDataSourceOMSheet">
                        <Columns>
                            <asp:TemplateField HeaderText="&nbsp;">
                                <HeaderTemplate>
                                    <asp:CheckBox ID="CheckBox2" runat="server" onclick="javascript:Selectallcheckbox(this);" />
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <asp:CheckBox ID="CheckBoxId" runat="server" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="ID" Visible="false">
                                <ItemTemplate>
                                    <asp:Label ID="DocumentId" runat="server" Text='<%# Bind("Id") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="DocumentName" HeaderText="Sheet Name" SortExpression="DocumentName" />
                            <asp:BoundField DataField="DocumentFile" HeaderText="File" SortExpression="DocumentFile" />
                            <asp:TemplateField HeaderText="Linked Projects">
                                <ItemTemplate>
                                    <asp:Label ID="Projects" runat="server" Text='<%# Common.getAllProjectsName("OMSheet", Convert.ToInt32(Eval("Id")).ToString()) %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderStyle-Width="20">
                                <ItemTemplate>
                                    <a id="downloadLink" class="btn btn-info btn-xs" title="Downlaod" href="OMSheet.aspx?Id=<%#Eval("Id") %>">
                                        <i class="fas fa-download"></i>
                                    </a>
                                    <asp:Button ID="deletebtn" runat="server" CommandName="Delete" CssClass="btn btn-danger btn-xs"
                                        Text="&nbsp;&nbsp;X&nbsp;&nbsp;" OnClientClick="return confirm('Are you sure you want to delete this item?');" />
                                </ItemTemplate>
                                <HeaderStyle Width="20px"></HeaderStyle>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                    <asp:SqlDataSource ID="SqlDataSourceOMSheet" runat="server" ConnectionString="<%$ ConnectionStrings:dbContext %>" SelectCommand="SELECT [Id], [DocumentName], substring([DocumentFile],11,250) AS DocumentFile FROM [OMSheet]" DeleteCommand="DELETE FROM [OMSheet] WHERE [Id] = @Id"></asp:SqlDataSource>
                </div>
                <!-- /.card-body -->
            </div>
        </div>
    </section>
</asp:Content>
