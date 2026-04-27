<%@ Page Title="File Manager" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Files.aspx.cs" Inherits="Files" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="page-header">
        <h1>File <span>Manager</span></h1>
        <p>// browse, download, and delete files</p>
    </div>

    <asp:Panel ID="pnlMsg" runat="server" Visible="false">
        <div class="alert alert-info">
            <i class="fa-solid fa-circle-info"></i>
            <asp:Literal ID="litMsg" runat="server" />
        </div>
    </asp:Panel>
    <asp:Panel ID="pnlErr" runat="server" Visible="false">
        <div class="alert alert-danger">
            <i class="fa-solid fa-triangle-exclamation"></i>
            <asp:Literal ID="litErr" runat="server" />
        </div>
    </asp:Panel>

    <div class="card">
        <div class="card-title" style="justify-content:space-between">
            <span><i class="fa-solid fa-folder-open"></i> All Files</span>
            <a href="Upload.aspx" class="btn btn-primary btn-sm"><i class="fa-solid fa-plus"></i> Upload New</a>
        </div>

        <asp:GridView ID="gvFiles" runat="server"
            AutoGenerateColumns="False"
            CssClass="data-table"
            OnRowCommand="gvFiles_RowCommand"
            EmptyDataText=""
            GridLines="None">
            <Columns>
                <asp:BoundField DataField="FileID"   HeaderText="#"         ItemStyle-CssClass="muted" />
                <asp:TemplateField HeaderText="File Name">
                    <ItemTemplate>
                        <span><i class="fa-solid fa-file" style="color:var(--accent);margin-right:.45rem"></i><%# Eval("FileName") %></span>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Size">
                    <ItemTemplate><%# FileManager.FormatFileSize(Convert.ToInt64(Eval("FileSize"))) %></ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Upload Date">
                    <ItemTemplate><%# Convert.ToDateTime(Eval("UploadDate")).ToString("MMM dd, yyyy  HH:mm") %></ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Actions">
                    <ItemTemplate>
                        <asp:LinkButton CommandName="DownloadFile" CommandArgument='<%# Eval("FileID") %>'
                            CssClass="btn btn-ghost btn-sm" runat="server">
                            <i class="fa-solid fa-download"></i> Download
                        </asp:LinkButton>
                        <asp:LinkButton CommandName="DeleteFile" CommandArgument='<%# Eval("FileID") %>'
                            CssClass="btn btn-danger btn-sm" runat="server"
                            OnClientClick="return confirm('Delete this file permanently?');">
                            <i class="fa-solid fa-trash"></i> Delete
                        </asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>

        <asp:Panel ID="pnlEmpty" runat="server" Visible="false">
            <div class="empty-state">
                <i class="fa-solid fa-folder-open"></i>
                <p>No files found. <a href="Upload.aspx" style="color:var(--accent)">Upload your first file</a></p>
            </div>
        </asp:Panel>
    </div>

</asp:Content>
