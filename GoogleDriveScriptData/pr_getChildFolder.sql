CREATE PROCEDURE GetChildFolders
    @ParentFolderId INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @ParentPath VARCHAR(255);
    SELECT @ParentPath = Path
    FROM Folder
    WHERE FolderId = @ParentFolderId;
    IF @ParentPath IS NOT NULL
    BEGIN
        SELECT 
            FolderId,
            ParentId,
            OwnerId,
            Name,
            Path,
            CreatedAt,
            UpdatedAt
        FROM Folder
        WHERE Path LIKE @ParentPath + '/%'
        ORDER BY FolderId;
    END
    ELSE
    BEGIN
        SELECT 
            FolderId,
            ParentId,
            OwnerId,
            Name,
            Path,
            CreatedAt,
            UpdatedAt
        FROM Folder
        WHERE 1 = 0;
    END
END;
GO