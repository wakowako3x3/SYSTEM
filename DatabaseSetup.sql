-- =====================================================
-- FileIOSystem – Database Setup Script
-- Run this in SQL Server Management Studio (SSMS)
-- or via sqlcmd before starting the web app.
-- =====================================================

USE master;
GO

-- Create database if it doesn't exist
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'FileIODB')
BEGIN
    CREATE DATABASE FileIODB;
    PRINT 'Database FileIODB created.';
END
GO

USE FileIODB;
GO

-- ─── Files table ──────────────────────────────────
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Files' AND xtype='U')
BEGIN
    CREATE TABLE Files (
        FileID      INT          IDENTITY(1,1) PRIMARY KEY,
        FileName    NVARCHAR(255) NOT NULL,
        FilePath    NVARCHAR(500) NOT NULL,
        FileSize    BIGINT        NOT NULL DEFAULT 0,
        UploadDate  DATETIME      NOT NULL DEFAULT GETDATE()
    );
    PRINT 'Table Files created.';
END
GO

-- ─── IOQueue table ────────────────────────────────
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='IOQueue' AND xtype='U')
BEGIN
    CREATE TABLE IOQueue (
        QueueID       INT           IDENTITY(1,1) PRIMARY KEY,
        FileID        INT           NOT NULL,
        OperationType NVARCHAR(50)  NOT NULL,   -- Upload | Download | Delete
        Status        NVARCHAR(50)  NOT NULL DEFAULT 'Pending',  -- Pending | Completed
        CreatedDate   DATETIME      NOT NULL DEFAULT GETDATE(),
        CONSTRAINT FK_IOQueue_Files FOREIGN KEY (FileID) REFERENCES Files(FileID) ON DELETE CASCADE
    );
    PRINT 'Table IOQueue created.';
END
GO

PRINT 'Setup complete.';
GO
