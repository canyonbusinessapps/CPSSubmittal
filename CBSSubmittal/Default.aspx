﻿<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="CBSSubmittal._Default" %>

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
            theDiv.Visible = true;
        }
        else
        {
            defaultProjectName = "Not Set";
            theDiv.Visible = false;
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
                    <div class="card-tools" runat="server" id="theDiv">
                        <a id="newSubmittal" href="<%=ResolveUrl("~/Project/CreateSubmittals.aspx") %>" class="btn btn-primary btn-md">
                            <asp:Button ID="btnCreateSubmittals" OnClick="btnCreateSubmittals_Click" CssClass="btn btn-xs btn-primary" runat="server" Text="CREATE SUBMITTALS" />
                        </a>
                    </div>
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
                                    <asp:TemplateField HeaderText="Ordering" SortExpression="Ordering" HeaderStyle-Width="100">
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
                    <asp:SqlDataSource ID="SqlDataSourceDocuments" runat="server" ConnectionString="<%$ ConnectionStrings:dbContext %>" SelectCommand="SELECT Id,ProjectId,DocumentName,substring([DocumentFile],11,250) AS DocumentFile,Details,Ordering  FROM [Document] WHERE ([ProjectId] = @ProjectId) ORDER BY [Ordering], [Id] DESC, [DocumentName]">
                        <SelectParameters>
                            <asp:SessionParameter Name="ProjectId" SessionField="defaultProject" Type="Int32" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                </div>
                <!-- /.card-body -->
            </div>

            <div class="card">
                <div class="card-header">
                    <h3 class="card-title">Spec Sheets for the project <span class="text-info text-bold"><% Response.Write(defaultProjectName); %></span></h3>
                </div>
                <!-- /.card-header -->
                <div class="card-body">
                    <asp:UpdatePanel ID="UpdatePanelSpecSheet" UpdateMode="Conditional" ChildrenAsTriggers="false" runat="server">
                        <ContentTemplate>
                            <asp:GridView ID="GridViewSpecSheet" runat="server" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="Id" DataSourceID="SqlDataSourceSpecSheet" CssClass="table table-striped table-bordered">
                                <AlternatingRowStyle BackColor="White" />
                                <Columns>
                                    <asp:BoundField DataField="Id" HeaderText="Id" InsertVisible="False" ReadOnly="True" SortExpression="Id" Visible="false" />
                                    <asp:BoundField DataField="DocumentName" HeaderText="Spec Sheet" SortExpression="DocumentName" />
                                    <asp:BoundField DataField="DocumentFile" HeaderText="File" SortExpression="DocumentFile" />
                                    <asp:TemplateField HeaderText="Ordering" SortExpression="Ordering" HeaderStyle-Width="100">
                                        <ItemTemplate>
                                            <asp:TextBox ID="txtOrdering" Text='<%# Bind("Ordering") %>' onkeypress="return ValDigit(this);" AutoPostBack="true" OnTextChanged="Update_Ordering_SpecSheet" runat="server" Style="width: 80px; text-align: center;" CssClass="form-control form-control-sm"></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderStyle-Width="20">
                                        <ItemTemplate>
                                            <a id="downloadLink" class="btn btn-info btn-xs" title="Downlaod" href="Project/SpecSheet.aspx?Id=<%#Eval("Id") %>">
                                                <i class="fas fa-download"></i>
                                            </a>
                                            <asp:Button ID="deletebtn" runat="server" CommandName="Delete" CssClass="btn btn-danger btn-xs"
                                        Text="&nbsp;&nbsp;X&nbsp;&nbsp;" OnClientClick="return confirm('Are you sure want to delete relationship from this project?');" />
                                        </ItemTemplate>
                                        <HeaderStyle Width="20px"></HeaderStyle>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                    <asp:SqlDataSource ID="SqlDataSourceSpecSheet" runat="server" ConnectionString="<%$ ConnectionStrings:dbContext %>"
                        SelectCommand="SELECT SS.[Id], SS.[DocumentName], substring(SS.[DocumentFile],11,250) AS DocumentFile, DR.[Ordering] FROM [SpecSheet] SS LEFT JOIN [DocumentRelation] DR ON DR.[DocumentId]=SS.[Id] WHERE (DR.[DocumentType] = 'SpecSheet' AND DR.[ProjectId]=@ProjectId) ORDER BY DR.[Ordering]"
                        DeleteCommand="DELETE FROM [DocumentRelation] WHERE ([DocumentType] = 'SpecSheet' AND [ProjectId] = @ProjectId AND [DocumentId] = @Id)">
                        <SelectParameters>
                            <asp:SessionParameter Name="ProjectId" SessionField="defaultProject" Type="Int32" />
                        </SelectParameters>
                        <DeleteParameters>
                            <asp:SessionParameter Name="ProjectId" SessionField="defaultProject" Type="Int32" />
                        </DeleteParameters>
                    </asp:SqlDataSource>
                </div>
                <!-- /.card-body -->
            </div>

            <div class="card">
                <div class="card-header">
                    <h3 class="card-title">O&M Sheets for the project <span class="text-info text-bold"><% Response.Write(defaultProjectName); %></span></h3>
                </div>
                <!-- /.card-header -->
                <div class="card-body">
                    <asp:UpdatePanel ID="UpdatePanelOMSheet" UpdateMode="Conditional" ChildrenAsTriggers="false" runat="server">
                        <ContentTemplate>
                            <asp:GridView ID="GridViewOMSheet" runat="server" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="Id" DataSourceID="SqlDataSourceOMSheet" CssClass="table table-striped table-bordered">
                                <AlternatingRowStyle BackColor="White" />
                                <Columns>
                                    <asp:BoundField DataField="Id" HeaderText="Id" InsertVisible="False" ReadOnly="True" SortExpression="Id" Visible="false" />
                                    <asp:BoundField DataField="DocumentName" HeaderText="O&M Sheet" SortExpression="DocumentName" />
                                    <asp:BoundField DataField="DocumentFile" HeaderText="File" SortExpression="DocumentFile" />
                                    <asp:TemplateField HeaderText="Ordering" SortExpression="Ordering" HeaderStyle-Width="100">
                                        <ItemTemplate>
                                            <asp:TextBox ID="txtOrdering" Text='<%# Bind("Ordering") %>' onkeypress="return ValDigit(this);" AutoPostBack="true" OnTextChanged="Update_Ordering_OMSheet" runat="server" Style="width: 80px; text-align: center;" CssClass="form-control form-control-sm"></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderStyle-Width="20">
                                        <ItemTemplate>
                                            <a id="downloadLink" class="btn btn-info btn-xs" title="Downlaod" href="Project/OMSheet.aspx?Id=<%#Eval("Id") %>">
                                                <i class="fas fa-download"></i>
                                            </a>
                                            <asp:Button ID="deletebtn" runat="server" CommandName="Delete" CssClass="btn btn-danger btn-xs"
                                        Text="&nbsp;&nbsp;X&nbsp;&nbsp;" OnClientClick="return confirm('Are you sure want to delete relationship from this project?');" />
                                        </ItemTemplate>
                                        <HeaderStyle Width="20px"></HeaderStyle>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                    <asp:SqlDataSource ID="SqlDataSourceOMSheet" runat="server" ConnectionString="<%$ ConnectionStrings:dbContext %>"
                        SelectCommand="SELECT SS.[Id], SS.[DocumentName], substring(SS.[DocumentFile],11,250) AS DocumentFile, DR.[Ordering] FROM [OMSheet] SS LEFT JOIN [DocumentRelation] DR ON DR.[DocumentId]=SS.[Id] WHERE (DR.[DocumentType] = 'OMSheet' AND DR.[ProjectId]=@ProjectId) ORDER BY DR.[Ordering]"
                        DeleteCommand="DELETE FROM [DocumentRelation] WHERE ([DocumentType] = 'OMSheet' AND [ProjectId] = @ProjectId AND [DocumentId] = @Id)">
                        <SelectParameters>
                            <asp:SessionParameter Name="ProjectId" SessionField="defaultProject" Type="Int32" />
                        </SelectParameters>
                        <DeleteParameters>
                            <asp:SessionParameter Name="ProjectId" SessionField="defaultProject" Type="Int32" />
                        </DeleteParameters>
                    </asp:SqlDataSource>
                </div>
                <!-- /.card-body -->
            </div>
        </div>
    </section>
</asp:Content>
