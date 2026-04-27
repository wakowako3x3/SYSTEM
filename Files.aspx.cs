using System;
using System.Data;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Files : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) LoadFiles();
    }

    private void LoadFiles()
    {
        DataTable dt = FileManager.GetAllFiles();
        if (dt.Rows.Count > 0)
        {
            gvFiles.DataSource = dt;
            gvFiles.DataBind();
            pnlEmpty.Visible = false;
        }
        else
        {
            gvFiles.Visible  = false;
            pnlEmpty.Visible = true;
        }
    }

    protected void gvFiles_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        pnlMsg.Visible = false;
        pnlErr.Visible = false;

        int fileId = Convert.ToInt32(e.CommandArgument);

        if (e.CommandName == "DownloadFile")
        {
            DownloadFile(fileId);
        }
        else if (e.CommandName == "DeleteFile")
        {
            DeleteFile(fileId);
        }
    }

    private void DownloadFile(int fileId)
    {
        DataRow row = FileManager.GetFileById(fileId);
        if (row == null) { ShowError("File record not found."); return; }

        string relPath  = row["FilePath"].ToString();
        string fileName = row["FileName"].ToString();
        string fullPath = Server.MapPath(relPath);

        if (!File.Exists(fullPath))
        {
            ShowError("Physical file not found on server.");
            return;
        }

        // Log download to queue
        FileManager.AddToQueue(fileId, "Download");
        FileManager.ProcessNextQueueItem();

        Response.Clear();
        Response.ContentType = "application/octet-stream";
        Response.AddHeader("Content-Disposition", "attachment; filename=\"" + fileName.Replace("\"", "") + "\"");
        Response.AddHeader("Content-Length", new FileInfo(fullPath).Length.ToString());
        Response.TransmitFile(fullPath);
        Response.End();
    }

    private void DeleteFile(int fileId)
    {
        try
        {
            DataRow row = FileManager.GetFileById(fileId);
            if (row == null) { ShowError("File record not found."); return; }

            string relPath  = row["FilePath"].ToString();
            string fileName = row["FileName"].ToString();

            // Log delete to queue first
            FileManager.AddToQueue(fileId, "Delete");
            FileManager.ProcessNextQueueItem();

            // Delete DB record (cascade deletes queue entries)
            FileManager.DeleteFile(fileId);

            // Delete physical file
            string fullPath = Server.MapPath(relPath);
            if (File.Exists(fullPath)) File.Delete(fullPath);

            ShowMessage("✓ <strong>" + HttpUtility.HtmlEncode(fileName) + "</strong> deleted successfully.");
            LoadFiles();
        }
        catch (Exception ex)
        {
            ShowError("Delete failed: " + ex.Message);
        }
    }

    private void ShowMessage(string msg) { litMsg.Text = msg; pnlMsg.Visible = true; }
    private void ShowError  (string msg) { litErr.Text = msg; pnlErr.Visible = true; }
}
