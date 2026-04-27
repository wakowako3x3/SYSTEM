<%@ Page Title="Dashboard" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="Default" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="page-header">
        <h1>System <span>Dashboard</span></h1>
        <p>// file &amp; i/o management overview</p>
    </div>

    <!-- STAT CARDS -->
    <div class="stats-row">
        <div class="stat-card">
            <div class="stat-label">Total Files</div>
            <div class="stat-value accent"><asp:Literal ID="litTotalFiles" runat="server" /></div>
        </div>
        <div class="stat-card">
            <div class="stat-label">Total Size</div>
            <div class="stat-value success"><asp:Literal ID="litTotalSize" runat="server" /></div>
        </div>
        <div class="stat-card">
            <div class="stat-label">Pending Queue</div>
            <div class="stat-value warning"><asp:Literal ID="litPending" runat="server" /></div>
        </div>
        <div class="stat-card">
            <div class="stat-label">Completed Ops</div>
            <div class="stat-value"><asp:Literal ID="litCompleted" runat="server" /></div>
        </div>
    </div>

    <!-- RECENT FILES -->
    <div class="card">
        <div class="card-title"><i class="fa-solid fa-clock-rotate-left"></i> Recent Uploads</div>
        <asp:Repeater ID="rptRecentFiles" runat="server">
            <HeaderTemplate>
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>File Name</th>
                            <th>Size</th>
                            <th>Uploaded</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
            </HeaderTemplate>
            <ItemTemplate>
                <tr>
                    <td><i class="fa-solid fa-file" style="color:var(--accent);margin-right:.5rem"></i><%# Eval("FileName") %></td>
                    <td><%# FileManager.FormatFileSize(Convert.ToInt64(Eval("FileSize"))) %></td>
                    <td><%# Convert.ToDateTime(Eval("UploadDate")).ToString("MMM dd, yyyy HH:mm") %></td>
                    <td>
                        <a href='Files.aspx' class="btn btn-ghost btn-sm"><i class="fa-solid fa-arrow-right"></i> Manage</a>
                    </td>
                </tr>
            </ItemTemplate>
            <FooterTemplate>
                    </tbody>
                </table>
            </FooterTemplate>
        </asp:Repeater>
        <asp:Panel ID="pnlNoFiles" runat="server" Visible="false">
            <div class="empty-state">
                <i class="fa-solid fa-folder-open"></i>
                <p>No files uploaded yet. <a href="Upload.aspx" style="color:var(--accent)">Upload your first file</a></p>
            </div>
        </asp:Panel>
    </div>

    <!-- QUICK ACTIONS -->
    <div class="card">
        <div class="card-title"><i class="fa-solid fa-bolt"></i> Quick Actions</div>
        <div style="display:flex;gap:1rem;flex-wrap:wrap">
            <a href="Upload.aspx"  class="btn btn-primary"><i class="fa-solid fa-upload"></i> Upload File</a>
            <a href="Files.aspx"   class="btn btn-ghost"><i class="fa-solid fa-folder-open"></i> Browse Files</a>
            <a href="IOQueue.aspx" class="btn btn-ghost"><i class="fa-solid fa-layer-group"></i> View Queue</a>
            <asp:Button ID="btnProcessAll" runat="server" Text=" Process All Queue" CssClass="btn btn-success"
                OnClick="btnProcessAll_Click" />
        </div>
    </div>

</asp:Content>
