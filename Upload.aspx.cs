using System;
using System.IO;
using System.Web;
using System.Web.UI;

public partial class Upload : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) LoadRecentFiles();
    }

    protected void btnUpload_Click(object sender, EventArgs e)
    {
        pnlSuccess.Visible = false;
        pnlError.Visible   = false;

        if (!fuFile.HasFile)
        {
            ShowError("Please select a file to upload.");
            return;
        }

        try
        {
            string uploadFolder = Server.MapPath("~/Uploads/");
            if (!Directory.Exists(uploadFolder))
                Directory.CreateDirectory(uploadFolder);

            // Unique filename to avoid collisions
            string originalName = Path.GetFileName(fuFile.FileName);
            string uniqueName   = DateTime.Now.ToString("yyyyMMdd_HHmmss") + "_" + originalName;
            string fullPath     = Path.Combine(uploadFolder, uniqueName);

            fuFile.SaveAs(fullPath);

            long   fileSize = fuFile.PostedFile.ContentLength;
            string relPath  = "~/Uploads/" + uniqueName;

            // Insert to DB + I/O queue
            int fileId = FileManager.InsertFile(originalName, relPath, fileSize);
            FileManager.AddToQueue(fileId, "Upload");
            FileManager.ProcessNextQueueItem();

            ShowSuccess("✓ <strong>" + HttpUtility.HtmlEncode(originalName) + "</strong> uploaded successfully (" + FileManager.FormatFileSize(fileSize) + ").");
            LoadRecentFiles();
        }
        catch (Exception ex)
        {
            ShowError("Upload failed: " + ex.Message);
        }
    }

    private void LoadRecentFiles()
    {
        var dt = FileManager.GetAllFiles();
        rptFiles.DataSource = dt;
        rptFiles.DataBind();
    }

    private void ShowSuccess(string msg) { litSuccess.Text = msg; pnlSuccess.Visible = true; }
    private void ShowError  (string msg) { litError.Text   = msg; pnlError.Visible   = true; }
}
