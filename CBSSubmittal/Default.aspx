<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="CBSSubmittal._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        function ValDigit(val) {
            var keyCodeEntered = (event.which) ? event.which : (window.event.keyCode) ? window.event.keyCode : -1;
            if ((keyCodeEntered >= 48) && (keyCodeEntered <= 57)) {
                return true;
            } else if (keyCodeEntered == 46) {
                if ((val.value) && (val.value.indexOf('.') >= 0))
                    return false;
                else
                    return true;
            }
            return false;
        }
    </script>
    <% 
        //Response.Write(Session["defaultProject"]);
        string defaultProjectName = null;
        string defaultProjectId = Convert.ToInt32(Session["defaultProject"]).ToString();
        if (defaultProjectId != "0")
        {
            defaultProjectName = Common.getProjectName(defaultProjectId);
        }
        else
        {
            defaultProjectName = "Not Set";
        }

    %>
    <!-- Content Header (Page header) -->
    <div class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1 class="m-0 text-dark">Dashboard</h1>
                </div>
                <!-- /.col -->
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right">
                        <li class="breadcrumb-item"><a href="~/" runat="server">Home</a></li>
                        <li class="breadcrumb-item active">Dashboard</li>
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
                    <h3 class="card-title">Documents for the project <span class="text-info text-bold"><% Response.Write(defaultProjectName); %></span></h3>
                </div>
                <!-- /.card-header -->
                <div class="card-body">
                    <asp:ScriptManager ID="ScriptManager1" runat="server">
                    </asp:ScriptManager>
                    <asp:UpdatePanel ID="upDocuments" UpdateMode="Conditional" ChildrenAsTriggers="false" runat="server">
                        <ContentTemplate>
                            <asp:GridView ID="grdDocuments" runat="server" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="Id" DataSourceID="SqlDataSourceDocuments" CssClass="table table-striped table-bordered">
                                <AlternatingRowStyle BackColor="White" />
                                <Columns>
                                    <asp:TemplateField HeaderText="ID" SortExpression="Id" Visible="false">
                                        <ItemTemplate>
                                            <asp:TextBox ID="txtId" runat="server" Text='<%# Bind("Id") %>'></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="ProjectId" HeaderText="Project Id" SortExpression="ProjectId" Visible="false" />
                                    <asp:BoundField DataField="DocumentName" HeaderText="Document Name" SortExpression="DocumentName" />
                                    <asp:BoundField DataField="DocumentFile" HeaderText="Document File" SortExpression="DocumentFile" />
                                    <asp:BoundField DataField="Details" HeaderText="Details" SortExpression="Details" />
                                    <asp:TemplateField HeaderText="Ordering" SortExpression="Ordering">
                                        <ItemTemplate>
                                            <asp:TextBox ID="txtOrdering" Text='<%# Bind("Ordering") %>' onkeypress="return ValDigit(this);" AutoPostBack="true" OnTextChanged="Update_Ordering" runat="server" Style="width: 80px; text-align: center;" CssClass="form-control form-control-sm"></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderStyle-Width="20">
                                        <ItemTemplate>
                                            <a id="downloadLink" class="btn btn-info btn-xs" title="Downlaod" href="Project/CreateDocument.aspx?Id=<%#Eval("Id") %>">
                                                <i class="fas fa-download"></i>
                                            </a>
                                        </ItemTemplate>
                                        <HeaderStyle Width="20px"></HeaderStyle>
                                    </asp:TemplateField>
                                </Columns>
                                <EditRowStyle BackColor="#2461BF" />
                                <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Right" />
                                <RowStyle BackColor="#EFF3FB" />
                                <SelectedRowStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                <SortedAscendingCellStyle BackColor="#F5F7FB" />
                                <SortedAscendingHeaderStyle BackColor="#6D95E1" />
                                <SortedDescendingCellStyle BackColor="#E9EBEF" />
                                <SortedDescendingHeaderStyle BackColor="#4870BE" />
                            </asp:GridView>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                    <asp:SqlDataSource ID="SqlDataSourceDocuments" runat="server" ConnectionString="<%$ ConnectionStrings:dbContext %>" SelectCommand="SELECT * FROM [Document] WHERE ([ProjectId] = @ProjectId) ORDER BY [Ordering], [Id] DESC, [DocumentName]">
                        <SelectParameters>
                            <asp:SessionParameter DefaultValue="1" Name="ProjectId" SessionField="defaultProject" Type="Int32" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                </div>
                <!-- /.card-body -->
            </div>
        </div>
    </section>
</asp:Content>
