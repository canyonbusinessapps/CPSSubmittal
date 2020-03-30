<%@ Page Title="Projects" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CreateProject.aspx.cs" Inherits="CBSSubmittal.Project.CreateProject" Debug="true" %>

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
                    <asp:GridView ID="GridView1" runat="server" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" CellPadding="4" DataKeyNames="Id" DataSourceID="SqlDataSource1" ForeColor="#333333" GridLines="None" CssClass="table table-striped table-bordered">
                        <AlternatingRowStyle BackColor="White" />
                        <Columns>
                            <asp:TemplateField HeaderText="Id" InsertVisible="False" SortExpression="Id" Visible="false">
                                <EditItemTemplate>
                                    <asp:Label ID="Label1" runat="server" Text='<%# Eval("Id") %>'></asp:Label>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="Label1" runat="server" Text='<%# Bind("Id") %>'></asp:Label>
                                </ItemTemplate>
                                <FooterTemplate>
                                    <asp:LinkButton ID="btnInsert" runat="server">Insert</asp:LinkButton>
                                </FooterTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Project Name" SortExpression="ProjectName">
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtProjectName" runat="server" Text='<%# Bind("ProjectName") %>'></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="reqProjectNameEdit" runat="server" ValidationGroup="UPDATE"
                                        ErrorMessage="Project Name is required." ControlToValidate="txtProjectName" Text="*" ForeColor="Red"></asp:RequiredFieldValidator>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="Label2" runat="server" Text='<%# Bind("ProjectName") %>'></asp:Label>
                                </ItemTemplate>
                                <FooterTemplate>
                                    <asp:TextBox ID="txtProjectNameNew" runat="server"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="reqProjectNameCreate" runat="server" ValidationGroup="INSERT"
                                        ErrorMessage="Project Name is required." ControlToValidate="txtProjectNameNew" Text="*" ForeColor="Red"></asp:RequiredFieldValidator>
                                </FooterTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Details" SortExpression="Details">
                                <EditItemTemplate>
                                    <asp:TextBox ID="TextBox2" runat="server" Text='<%# Bind("Details") %>'></asp:TextBox>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="Label3" runat="server" Text='<%# Bind("Details") %>'></asp:Label>
                                </ItemTemplate>
                                <FooterTemplate>
                                    <asp:TextBox ID="txtDetails" runat="server"></asp:TextBox>
                                </FooterTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Status" SortExpression="Status">
                                <EditItemTemplate>
                                    <asp:DropDownList ID="DropDownListStatus" runat="server" SelectedValue='<%# Bind("Status") %>'>
                                        <asp:ListItem Value=""> Select Status </asp:ListItem>
                                        <asp:ListItem Value="Active"> Active </asp:ListItem>
                                        <asp:ListItem Value="Inactive"> Inactive </asp:ListItem>
                                    </asp:DropDownList>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="Label4" runat="server" Text='<%# Bind("Status") %>'></asp:Label>
                                </ItemTemplate>
                                <FooterTemplate>
                                    <asp:DropDownList ID="DropDownListStatus" runat="server">
                                        <asp:ListItem Value=""> Select Status </asp:ListItem>
                                        <asp:ListItem Value="Active"> Active </asp:ListItem>
                                        <asp:ListItem Value="Inactive"> Inactive </asp:ListItem>
                                    </asp:DropDownList>
                                </FooterTemplate>
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
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <EditRowStyle BackColor="#2461BF" />
                        <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                        <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                        <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
                        <RowStyle BackColor="#EFF3FB" />
                        <SelectedRowStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                        <SortedAscendingCellStyle BackColor="#F5F7FB" />
                        <SortedAscendingHeaderStyle BackColor="#6D95E1" />
                        <SortedDescendingCellStyle BackColor="#E9EBEF" />
                        <SortedDescendingHeaderStyle BackColor="#4870BE" />
                    </asp:GridView>
                    <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:dbContext %>" DeleteCommand="DELETE FROM [Project] WHERE [Id] = @Id" InsertCommand="INSERT INTO [Project] ([ProjectName], [Details], [Status]) VALUES (@ProjectName, @Details, @Status)" SelectCommand="SELECT * FROM [Project]" UpdateCommand="UPDATE [Project] SET [ProjectName] = @ProjectName, [Details] = @Details, [Status] = @Status WHERE [Id] = @Id">
                        <DeleteParameters>
                            <asp:Parameter Name="Id" Type="Int32" />
                        </DeleteParameters>
                        <InsertParameters>
                            <asp:Parameter Name="ProjectName" Type="String" />
                            <asp:Parameter Name="Details" Type="String" />
                            <asp:Parameter Name="Status" Type="String" />
                        </InsertParameters>
                        <UpdateParameters>
                            <asp:Parameter Name="ProjectName" Type="String" />
                            <asp:Parameter Name="Details" Type="String" />
                            <asp:Parameter Name="Status" Type="String" />
                            <asp:Parameter Name="Id" Type="Int32" />
                        </UpdateParameters>
                    </asp:SqlDataSource>

                    <%--                    
                        <asp:GridView ID="grdProject" AutoGenerateColumns="false" runat="server" CssClass="table table-striped table-bordered" OnRowDeleting="GridView_RowDeleting" DataKeyNames="Id">
                        <Columns>
                            <asp:BoundField DataField="ProjectName" HeaderText="Project Name" />
                            <asp:BoundField DataField="Details" HeaderText="Details" />
                            <asp:BoundField DataField="Status" HeaderText="Status" />
                            <asp:TemplateField HeaderStyle-Width="20">
                                <ItemTemplate>
                                    <asp:Button ID="deletebtn" runat="server" CommandName="Delete" CssClass="btn btn-danger btn-xs"
                                        Text="&nbsp;&nbsp;x&nbsp;&nbsp;" OnClientClick="return confirm('Are you sure you want to delete this item?');" />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>--%>
                </div>
                <!-- /.card-body -->
            </div>
        </div>
    </section>
    <%--<asp:SqlDataSource ID="dbContext" runat="server" ConnectionString="<%$ ConnectionStrings:dbContext %>" SelectCommand="SELECT * FROM [Project]"></asp:SqlDataSource>--%>
</asp:Content>
