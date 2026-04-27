using System;
using System.Data;
using System.Web.UI;

public partial class Default : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) LoadDashboard();
    }

    private void LoadDashboard()
    {
        // Stats
        DataTable files = FileManager.GetAllFiles();
        long totalSize = 0;
        foreach (DataRow row in files.Rows)
            totalSize += Convert.ToInt64(row["FileSize"]);

        litTotalFiles.Text = files.Rows.Count.ToString();
        litTotalSize.Text  = FileManager.FormatFileSize(totalSize);
        litPending.Text    = FileManager.GetPendingCount().ToString();

        DataTable queue = FileManager.GetQueue();
        int completed = 0;
        foreach (DataRow row in queue.Rows)
            if (row["Status"].ToString() == "Completed") completed++;
        litCompleted.Text = completed.ToString();

        // Recent 5 files
        DataTable recent = files.Rows.Count > 0 ? files : new DataTable();
        DataTable top5 = recent.Clone();
        int count = Math.Min(5, recent.Rows.Count);
        for (int i = 0; i < count; i++) top5.ImportRow(recent.Rows[i]);

        if (top5.Rows.Count > 0)
        {
            rptRecentFiles.DataSource = top5;
            rptRecentFiles.DataBind();
            pnlNoFiles.Visible = false;
        }
        else
        {
            rptRecentFiles.Visible = false;
            pnlNoFiles.Visible = true;
        }
    }

    protected void btnProcessAll_Click(object sender, EventArgs e)
    {
        FileManager.ProcessAllPending();
        LoadDashboard();
    }
}
