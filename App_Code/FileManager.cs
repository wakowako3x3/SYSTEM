using System;
using System.Data;
using System.Data.SqlClient;
using System.IO;

public class FileManager
{
    // ──────────────────────────────────────────────
    //  FILES
    // ──────────────────────────────────────────────

    public static DataTable GetAllFiles()
    {
        return DatabaseHelper.ExecuteQuery(
            "SELECT FileID, FileName, FilePath, FileSize, UploadDate FROM Files ORDER BY UploadDate DESC");
    }

    public static int InsertFile(string fileName, string filePath, long fileSize)
    {
        string query = @"INSERT INTO Files (FileName, FilePath, FileSize, UploadDate)
                         VALUES (@FileName, @FilePath, @FileSize, @UploadDate);
                         SELECT SCOPE_IDENTITY();";
        var p = new SqlParameter[]
        {
            new SqlParameter("@FileName",   fileName),
            new SqlParameter("@FilePath",   filePath),
            new SqlParameter("@FileSize",   fileSize),
            new SqlParameter("@UploadDate", DateTime.Now)
        };
        object result = DatabaseHelper.ExecuteScalar(query, p);
        return Convert.ToInt32(result);
    }

    public static DataRow GetFileById(int fileId)
    {
        var p = new SqlParameter[] { new SqlParameter("@FileID", fileId) };
        DataTable dt = DatabaseHelper.ExecuteQuery(
            "SELECT * FROM Files WHERE FileID = @FileID", p);
        return dt.Rows.Count > 0 ? dt.Rows[0] : null;
    }

    public static void DeleteFile(int fileId)
    {
        var p = new SqlParameter[] { new SqlParameter("@FileID", fileId) };
        DatabaseHelper.ExecuteNonQuery("DELETE FROM Files WHERE FileID = @FileID", p);
    }

    // ──────────────────────────────────────────────
    //  I/O QUEUE
    // ──────────────────────────────────────────────

    public static DataTable GetQueue()
    {
        return DatabaseHelper.ExecuteQuery(
            @"SELECT q.QueueID, f.FileName, q.OperationType, q.Status, q.CreatedDate
              FROM IOQueue q
              INNER JOIN Files f ON q.FileID = f.FileID
              ORDER BY q.CreatedDate DESC");
    }

    public static void AddToQueue(int fileId, string operationType)
    {
        string query = @"INSERT INTO IOQueue (FileID, OperationType, Status, CreatedDate)
                         VALUES (@FileID, @OperationType, 'Pending', @CreatedDate)";
        var p = new SqlParameter[]
        {
            new SqlParameter("@FileID",        fileId),
            new SqlParameter("@OperationType", operationType),
            new SqlParameter("@CreatedDate",   DateTime.Now)
        };
        DatabaseHelper.ExecuteNonQuery(query, p);
    }

    public static void ProcessNextQueueItem()
    {
        // Grab the oldest Pending item
        DataTable dt = DatabaseHelper.ExecuteQuery(
            "SELECT TOP 1 QueueID FROM IOQueue WHERE Status = 'Pending' ORDER BY CreatedDate ASC");
        if (dt.Rows.Count == 0) return;

        int queueId = Convert.ToInt32(dt.Rows[0]["QueueID"]);
        var p = new SqlParameter[] { new SqlParameter("@QueueID", queueId) };
        DatabaseHelper.ExecuteNonQuery(
            "UPDATE IOQueue SET Status = 'Completed' WHERE QueueID = @QueueID", p);
    }

    public static void ProcessAllPending()
    {
        DatabaseHelper.ExecuteNonQuery(
            "UPDATE IOQueue SET Status = 'Completed' WHERE Status = 'Pending'");
    }

    public static int GetPendingCount()
    {
        object result = DatabaseHelper.ExecuteScalar(
            "SELECT COUNT(*) FROM IOQueue WHERE Status = 'Pending'");
        return Convert.ToInt32(result);
    }

    // ──────────────────────────────────────────────
    //  HELPERS
    // ──────────────────────────────────────────────

    public static string FormatFileSize(long bytes)
    {
        if (bytes < 1024)        return bytes + " B";
        if (bytes < 1048576)     return string.Format("{0:F1} KB", bytes / 1024.0);
        if (bytes < 1073741824)  return string.Format("{0:F1} MB", bytes / 1048576.0);
        return string.Format("{0:F1} GB", bytes / 1073741824.0);
    }
}
