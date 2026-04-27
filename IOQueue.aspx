<%@ Page Title="I/O Queue" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="IOQueue.aspx.cs" Inherits="IOQueue" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="page-header">
        <h1>I/O <span>Queue</span></h1>
        <p>// sequential file request processing</p>
    </div>

    <asp:Panel ID="pnlMsg" runat="server" Visible="false">
        <div class="alert alert-success">
            <i class="fa-solid fa-circle-check"></i>
            <asp:Literal ID="litMsg" runat="server" />
        </div>
    </asp:Panel>

    <!-- QUEUE STATS -->
    <div class="stats-row" style="grid-template-columns:repeat(3,1fr)">
        <div class="stat-card">
            <div class="stat-label">Total Entries</div>
            <div class="stat-value accent"><asp:Literal ID="litTotal" runat="server" /></div>
        </div>
        <div class="stat-card">
            <div class="stat-label">Pending</div>
            <div class="stat-value warning"><asp:Literal ID="litPending" runat="server" /></div>
        </div>
        <div class="stat-card">
            <div class="stat-label">Completed</div>
            <div class="stat-value success"><asp:Literal ID="litCompleted" runat="server" /></div>
        </div>
    </div>

    <!-- ACTIONS -->
    <div class="card">
        <div class="card-title"><i class="fa-solid fa-gears"></i> Queue Controls</div>
        <div style="display:flex;gap:.75rem;flex-wrap:wrap">
            <asp:Button ID="btnProcessNext" runat="server" Text=" Process Next"
                CssClass="btn btn-primary" OnClick="btnProcessNext_Click" />
            <asp:Button ID="btnProcessAll"  runat="server" Text=" Process All"
                CssClass="btn btn-success"  OnClick="btnProcessAll_Click" />
            <asp:Button ID="btnRefresh"     runat="server" Text=" Refresh"
                CssClass="btn btn-ghost"    OnClick="btnRefresh_Click" />
        </div>
    </div>

    <!-- QUEUE TABLE -->
    <div class="card">
        <div class="card-title"><i class="fa-solid fa-list-check"></i> Request Queue</div>

        <asp:Repeater ID="rptQueue" runat="server">
            <HeaderTemplate>
                <table class="data-table">
                    <thead><tr>
                        <th>Queue ID</th>
                        <th>File Name</th>
                        <th>Operation</th>
                        <th>Status</th>
                        <th>Queued At</th>
                    </tr></thead>
                    <tbody>
            </HeaderTemplate>
            <ItemTemplate>
                <tr>
                    <td style="color:var(--muted)">#<%# Eval("QueueID") %></td>
                    <td><i class="fa-solid fa-file" style="color:var(--accent);margin-right:.4rem"></i><%# Eval("FileName") %></td>
                    <td>
                        <span class="badge badge-<%# Eval("OperationType").ToString().ToLower() %>">
                            <%# Eval("OperationType") %>
                        </span>
                    </td>
                    <td>
                        <span class="badge <%# Eval("Status").ToString() == "Completed" ? "badge-completed" : "badge-pending" %>">
                            <i class="fa-solid <%# Eval("Status").ToString() == "Completed" ? "fa-check" : "fa-clock" %>"></i>
                            <%# Eval("Status") %>
                        </span>
                    </td>
                    <td><%# Convert.ToDateTime(Eval("CreatedDate")).ToString("MMM dd, yyyy  HH:mm:ss") %></td>
                </tr>
            </ItemTemplate>
            <FooterTemplate>
                    </tbody></table>
            </FooterTemplate>
        </asp:Repeater>

        <asp:Panel ID="pnlEmpty" runat="server" Visible="false">
            <div class="empty-state">
                <i class="fa-solid fa-inbox"></i>
                <p>The queue is empty. Operations will appear here after file actions.</p>
            </div>
        </asp:Panel>
    </div>

</asp:Content>
