<%@ Page Title="Upload File" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Upload.aspx.cs" Inherits="Upload" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="page-header">
        <h1>Upload <span>File</span></h1>
        <p>// add files to the system and queue</p>
    </div>

    <asp:Panel ID="pnlSuccess" runat="server" Visible="false">
        <div class="alert alert-success">
            <i class="fa-solid fa-circle-check"></i>
            <asp:Literal ID="litSuccess" runat="server" />
        </div>
    </asp:Panel>

    <asp:Panel ID="pnlError" runat="server" Visible="false">
        <div class="alert alert-danger">
            <i class="fa-solid fa-circle-exclamation"></i>
            <asp:Literal ID="litError" runat="server" />
        </div>
    </asp:Panel>

    <div style="display:grid;grid-template-columns:1fr 1fr;gap:1.5rem">

        <!-- UPLOAD CARD -->
        <div class="card">
            <div class="card-title"><i class="fa-solid fa-upload"></i> Select &amp; Upload</div>

            <div class="file-drop" id="dropZone">
                <i class="fa-solid fa-cloud-arrow-up"></i>
                <asp:FileUpload ID="fuFile" runat="server" CssClass="hidden" />
                <p>Drag &amp; drop a file here, or click to browse</p>
                <small style="color:var(--muted);font-family:var(--mono);font-size:.75rem">Max 50 MB</small>
            </div>

            <div style="margin-top:1.2rem">
                <asp:Button ID="btnUpload" runat="server" Text="Upload File"
                    CssClass="btn btn-primary" OnClick="btnUpload_Click" />
                <a href="Files.aspx" class="btn btn-ghost" style="margin-left:.75rem">
                    <i class="fa-solid fa-folder-open"></i> View Files
                </a>
            </div>
        </div>

        <!-- INFO CARD -->
        <div class="card">
            <div class="card-title"><i class="fa-solid fa-circle-info"></i> How it Works</div>
            <div style="display:flex;flex-direction:column;gap:1rem">
                <div style="display:flex;align-items:flex-start;gap:.75rem">
                    <div style="background:rgba(0,229,255,.1);color:var(--accent);border-radius:8px;padding:.4rem .65rem;font-weight:800;font-size:.85rem;flex-shrink:0">01</div>
                    <div>
                        <div style="font-weight:700;font-size:.9rem">Select a File</div>
                        <div style="color:var(--muted);font-size:.82rem;font-family:var(--mono)">Choose any file from your device documents, images, archives, etc.</div>
                    </div>
                </div>
                <div style="display:flex;align-items:flex-start;gap:.75rem">
                    <div style="background:rgba(0,229,255,.1);color:var(--accent);border-radius:8px;padding:.4rem .65rem;font-weight:800;font-size:.85rem;flex-shrink:0">02</div>
                    <div>
                        <div style="font-weight:700;font-size:.9rem">Stored + Metadata</div>
                        <div style="color:var(--muted);font-size:.82rem;font-family:var(--mono)">File is saved to the server and metadata is written to the database.</div>
                    </div>
                </div>
                <div style="display:flex;align-items:flex-start;gap:.75rem">
                    <div style="background:rgba(0,229,255,.1);color:var(--accent);border-radius:8px;padding:.4rem .65rem;font-weight:800;font-size:.85rem;flex-shrink:0">03</div>
                    <div>
                        <div style="font-weight:700;font-size:.9rem">I/O Queue Entry</div>
                        <div style="color:var(--muted);font-size:.82rem;font-family:var(--mono)">An "Upload" request is added to the I/O queue and processed sequentially.</div>
                    </div>
                </div>
            </div>
        </div>

    </div>

    <!-- LAST UPLOADED -->
    <div class="card">
        <div class="card-title"><i class="fa-solid fa-history"></i> Recently Uploaded</div>
        <asp:Repeater ID="rptFiles" runat="server">
            <HeaderTemplate>
                <table class="data-table">
                    <thead><tr>
                        <th>#</th><th>File Name</th><th>Size</th><th>Date</th>
                    </tr></thead>
                    <tbody>
            </HeaderTemplate>
            <ItemTemplate>
                <tr>
                    <td style="color:var(--muted)"><%# Eval("FileID") %></td>
                    <td><i class="fa-solid fa-file" style="color:var(--accent);margin-right:.4rem"></i><%# Eval("FileName") %></td>
                    <td><%# FileManager.FormatFileSize(Convert.ToInt64(Eval("FileSize"))) %></td>
                    <td><%# Convert.ToDateTime(Eval("UploadDate")).ToString("MMM dd, yyyy HH:mm") %></td>
                </tr>
            </ItemTemplate>
            <FooterTemplate>
                    </tbody></table>
            </FooterTemplate>
        </asp:Repeater>
    </div>

    <script>
        // wire drop-zone to the hidden FileUpload
        (function () {
            var zone  = document.getElementById('dropZone');
            var input = document.getElementById('<%= fuFile.ClientID %>');
            if (!zone || !input) return;
            input.style.display = 'none';
            zone.style.cursor = 'pointer';
            zone.addEventListener('click', function () { input.click(); });
            zone.addEventListener('dragover',  function (e) { e.preventDefault(); zone.style.borderColor = 'var(--accent)'; });
            zone.addEventListener('dragleave', function ()  { zone.style.borderColor = ''; });
            zone.addEventListener('drop', function (e) {
                e.preventDefault(); zone.style.borderColor = '';
                if (e.dataTransfer.files.length) {
                    input.files = e.dataTransfer.files;
                    zone.querySelector('p').textContent = e.dataTransfer.files[0].name;
                }
            });
            input.addEventListener('change', function () {
                if (input.files.length) zone.querySelector('p').textContent = input.files[0].name;
            });
        })();
    </script>
</asp:Content>
