using System;
using System.Data;
using System.Web.UI;

public partial class IOQueue : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) LoadQueue();
    }

    private void LoadQueue()
    {
        DataTable dt = FileManager.GetQueue();
        int pending   = 0;
        int completed = 0;

        foreach (DataRow row in dt.Rows)
        {
            if (row["Status"].ToString() == "Pending")   pending++;
            else                                         completed++;
        }

        litTotal.Text     = dt.Rows.Count.ToString();
        litPending.Text   = pending.ToString();
        litCompleted.Text = completed.ToString();

        if (dt.Rows.Count > 0)
        {
            rptQueue.DataSource = dt;
            rptQueue.DataBind();
            pnlEmpty.Visible = false;
        }
        else
        {
            rptQueue.Visible = false;
            pnlEmpty.Visible = true;
        }
    }

    protected void btnProcessNext_Click(object sender, EventArgs e)
    {
        FileManager.ProcessNextQueueItem();
        ShowMessage(" Next pending item processed.");
        LoadQueue();
    }

    protected void btnProcessAll_Click(object sender, EventArgs e)
    {
        FileManager.ProcessAllPending();
        ShowMessage(" All pending items processed.");
        LoadQueue();
    }

    protected void btnRefresh_Click(object sender, EventArgs e)
    {
        LoadQueue();
    }

    private void ShowMessage(string msg) { litMsg.Text = msg; pnlMsg.Visible = true; }
}
