USE GoogleDrive
GO

 -- Home screen
 -- select User information
 Declare @userId int = 1
 select 
	a.UserName as UserName,
	a.Email as Email
 from Account a
 where a.UserId =@userId 


-- select User Setting
Declare @userId int = 1;
select 
	a.UserName as UserName,
	s.SettingKey,
	s.SettingValue
from SettingUser su
join Account a on su.UserId = a.UserId
join AppSetting s on su.SettingId = s.SettingId
where a.UserId =@userId


-- select login user file
Declare @LoginUser int = 1 
select 
	a.UserName ,
	uf.UserFileName
from UserFile uf 
join Account a on uf.OwnerId = a.UserId
where a.UserId =@LoginUser


-- select login user folder
Declare @userId int = 1
select 
	a.UserName ,
	fo.FolderName
from Folder fo
join Account a on fo.OwnerId = a.UserId
where a.UserId =@userId


-- select shared file with login user
Declare @userId int = 102
select 
	a.UserName,
	f.UserFileName
from SharedUser su
join Account a on su.UserId = a.UserId
join Share s on su.ShareId = s.ShareId
join UserFile f on s.ObjectTypeId = 2 and s.ObjectId = f.FileId
where su.UserId = @userId


select * from Share
select * from Shareduser where shareId =2


-- select shared folder with login user
Declare @userId int = 101
select 
	a.UserName,
	fo.FolderName
from SharedUser su
join Account a on su.UserId = a.UserId
join Share s on su.ShareId = s.ShareId
join [Folder] fo on s.ObjectTypeId =1 and s.ObjectId = fo.FolderId
where su.UserId = @userId

select * from share where ObjectTypeId =1
select * from SharedUser where ShareId = 1


--Recomment file/folder
Declare @userId int = 2
select top 10
	a.UserName,
	f.UserFileName,
	ar.ActionLog,
	ar.ActionDateTime
from ActionRecent ar 
join Account a on ar.UserId = a.UserId
join UserFile f on ar.ObjectTypeId = 2 and ar.ObjectId = f.FileId
where ar.UserId = @userId
order by ar.ActionDateTime DESC

select * from ActionRecent


--Recomment folder
Declare @userId int = 3
select top 10
	a.UserName,
	fo.FolderName,
	ar.ActionLog,
	ar.ActionDateTime
from ActionRecent ar
join Account a on ar.UserId = a.UserId
join Folder fo on ar.ObjectTypeId = 1 and ar.ObjectId = fo.FolderId
where ar.UserId = @userId  
order by ar.ActionDateTime DESC

select * from ActionRecent


-- trash screen
--select file have been deleted
Declare @userId int = 704
 SELECT 
    t.TrashId,
    ot.ObjectTypeName,
    f.UserFileName,
    t.RemovedDatetime,
    t.IsPermanent
FROM Trash t
JOIN ObjectType ot ON t.ObjectTypeId = ot.ObjectTypeId
JOIN UserFile f ON t.ObjectTypeId = 2 AND t.ObjectId = f.FileId
WHERE t.UserId = @userId;

select * from Trash


--select folder have been deleted
Declare @userId int = 1
 SELECT 
    t.TrashId,
    ot.ObjectTypeName,
    fo.FolderName,
    t.RemovedDatetime,
    t.IsPermanent
FROM Trash t
JOIN ObjectType ot ON t.ObjectTypeId = ot.ObjectTypeId
JOIN Folder fo ON t.ObjectTypeId = 1 AND t.ObjectId = fo.FolderId
WHERE t.UserId = @userId;


-- Stared screen
-- Select file
Declare @userId int = 794
select 
	f.UserFileName,
	a.USerName as FileOwnerName,
	a.UserId as UserId,
	ft.FileTypeName
from FavoriteObject fa
left join UserFile f on fa.ObjectTypeId = 2 and fa.ObjectId = f.FileId
left join Account a on f.OwnerId = a.UserId 
join FileType ft on f.FileTypeId = ft.FileTypeId
where fa.OwnerId = @userId

select * from FavoriteObject where OwnerId = 794
select * from UserFile f where f.FileId = 875


--product Screen
-- select all of product
select
	ProductName,
	Cost,
	Duration
from ProductItem


-- select Product bought by user
Declare @userId int = 100
select 
	pro.ProductName,
	a.UserId,
	a.UserName,
	case
		when po.IsPercent = 1 then pro.Cost - (pro.Cost * (po.Discount/100))
		else pro.Cost - po.Discount
	end as TotalCost
from UserProduct up
join Account a on up.UserId = a.UserId
join Promotion po on up.PromotionId = po.PromotionId
join ProductItem pro on up.ProductId = pro.ProductId
where up.UserId = @userId

select * from Promotion where PromotionId = 1 or PromotionId = 4
select * from ProductItem
select * from UserProduct up where up.UserId = 100


-- select Top 10 Payers 
select top 10
	pro.ProductName,
	a.UserName,
	case
		when po.IsPercent = 1 then pro.Cost * (po.Discount/100)
		else pro.Cost - po.Discount
	end as TotalCost
from UserProduct up
join Account a on up.UserId = a.UserId
join ProductItem pro on up.ProductId = pro.ProductId
join Promotion po on up.PromotionId = po.PromotionId
order by TotalCost DESC


-- select file/folder shared for user with userid = 101
Declare @userId int = 101
select 
	a.UserName,
	p.PermissionName,
	f.UserFileName,
	fo.FolderName
from SharedUser su
join Account a on su.SharedUserId = a.UserId
join Share s on su.ShareId = s.ShareId
join Permission p on su.PermissionId = p.PermissionId
LEFT join Folder fo on s.ObjectTypeId = 1 and fo.FolderId = s.ObjectId
LEFT join UserFile f on s.ObjectTypeId = 2 and f.FileId = s.ObjectId
where su.UserId = @userId


select * from SharedUser su where su.SharedUserId = 500
select * from share s where s.ShareId = 1
select * from UserFile f where f.FileId = 298
select * from Account where UserId = 101


--select top 5 largest file 
select distinct top 5
	f.UserFileName,
	a.UserName as OwnerName,
	f.Size as FileSize
from UserFile f
join Account a on f.OwnerId = a.UserId
order by f.Size DESC


--select banned user
SELECT 
    BU.Id AS BanId,
    Banned.UserName AS BannedUserName,
    Banner.UserName AS BannedByUserName,
    BU.BannedAt
FROM BannedUser BU
JOIN Account Banned ON BU.UserId = Banned.UserId
JOIN Account Banner ON BU.BannedUserId = Banner.UserId
ORDER BY BU.BannedAt DESC;


--select product bought by user 
Declare @userId int = 100
select 
	p.ProductName,
	a.UserName,
	up.PayingDatetime,
	up.EndDatetime,
	pr.PromotionName
from UserProduct up
join ProductItem p on up.ProductId = p.ProductId
join Account a on up.UserId = a.UserId
join Promotion pr on up.PromotionId = pr.PromotionId
where a.UserId = @userId


-- select file share by user
Declare @userId int = 100
select 
	a.UserName,
	f.UserFileName
from Share s
join Account a on s.Sharer = a.UserId
join ObjectType ot on s.ObjectTypeId = ot.ObjectTypeId
left join UserFile f on s.ObjectTypeId = 2 and s.ObjectId = f.FileId
where s.Sharer = @userId


-- select folder share by user
Declare @userId int = 1
select 
	a.UserName,
	fo.FolderName
from Share s
join Account a on s.Sharer = a.UserId
join ObjectType ot on s.ObjectTypeId = ot.ObjectTypeId
left join [Folder] fo on s.ObjectTypeId =1 and s.ObjectId = fo.FolderId
where s.Sharer = @userId

select count(*)
from Share
group by Share.Sharer

select *
from Share
where ObjectId = 654


-- select user was shared object with objectId = 5
Declare @objectId int = 5
select 
	a.UserName,
	f.UserFileName,
	fo.FolderName,
	p.PermissionName
from Share s
	join SharedUser su on s.ShareId = su.ShareId
	join Account a on su.UserId = a.UserId
	join Permission p on su.PermissionId = p.PermissionId
	left join UserFile f on s.ObjectTypeId =2 and s.ObjectId = f.FileId
	left join [Folder] fo on s.ObjectTypeId =1 and s.ObjectId = fo.FolderId
where s.ObjectId = @objectId


select *
from UserFile fm
where f.FileId = 654

select *
from [Folder] f
where f.FolderId = 654


--User Management: Retrieve the names and email addresses of all users who have used more than 50% of their storage capacity.
select top 5
	a.UserName,
	a.Email as UserEmail,
	(a.capacity - a.UsedCapacity) as AllowCapicity
from Account a
where ((CAST(a.UsedCapacity AS FLOAT) / a.Capacity) * 100) > 50

select * from Account


--Folder Structure: List all folders owned by a specific user (e.g., UserId = 1), including their full path and the name of the color associated with each folder.
Declare @userId int = 20
select 
	fo.FolderPath,
	c.ColorName,
	a.UserName
from [Folder] fo
join Account a on fo.OwnerId = a.UserId
join Color c on fo.ColorId = c.ColorId
where fo.OwnerId = @userId


---Select childrent of folder
Declare @FolderId int = 1;
WITH RecursiveFolders AS (
    -- Anchor member: Start with FolderId = 1
    SELECT FolderId, FolderName, ParentId, FolderPath
    FROM Folder
    WHERE FolderId = @FolderId
    UNION ALL
    -- Recursive member: Join with Folder to get all descendants
    SELECT f.FolderId, f.FolderName, f.ParentId, f.FolderPath
    FROM Folder f
    INNER JOIN RecursiveFolders rf ON f.ParentId = rf.FolderId
    WHERE f.FolderPath LIKE rf.FolderPath + '/%'
)
SELECT 
    rf.FolderName,
    rf.ParentId,
    rf.FolderPath,
    fo.FolderName AS ParentFolderName
FROM RecursiveFolders rf
LEFT JOIN Folder fo ON rf.ParentId = fo.FolderId
WHERE rf.FolderId != 1 -- Exclude the root folder itself, only show subfolders
ORDER BY rf.FolderPath;


-- Full-text search query
-- Searches for files containing the term 'project' or 'proposal'
DECLARE @k1 FLOAT = 1.2; -- Term frequency saturation parameter
DECLARE @b FLOAT = 0.75; -- Length normalization parameter
DECLARE @avgdl FLOAT = (SELECT AVG(CAST(DocumentLength AS FLOAT)) FROM SearchIndex WHERE ObjectTypeId = 1); -- Average document length

SELECT 
    f.FileId,
    f.UserFileName,
    s.Term,
    s.TermFrequency,
	s.TermPositions,
    t.IDF,
    (t.IDF * s.TermFrequency * (@k1 + 1)) / 
    (s.TermFrequency + @k1 * (1 - @b + @b * (s.DocumentLength / @avgdl))) AS BM25_Score
FROM SearchIndex s
JOIN TermIDF t ON s.Term = t.Term
JOIN UserFile f ON s.ObjectId = f.FileId
WHERE s.ObjectTypeId = 1 
AND s.Term IN ('project', 'proposal')
ORDER BY BM25_Score DESC;


select 
	uf.UserFileName
from UserFile uf
where FileId = 1

---Sort UserFile By ShareUser where UserId = 2---
declare @Sharer int = 2
declare @shared int = 102
select 
	ft.Icon,
	uf.UserFileName as NameOfFile,
	a1.UserName as SharerName,
	s.CreatedAt as ShareDateTime,
	a.UserName as sharedName
from SharedUser su
join Share s on su.ShareId = s.ShareId
left join UserFile uf on s.ObjectTypeId = 2 and s.ObjectId = uf.FileId
join FileType ft on uf.FileTypeId = ft.FileTypeId
join Account a on su.UserId = a.UserId
join Account a1 on s.Sharer = a1.UserId
where su.UserId = @shared and s.Sharer = @Sharer

select * from SharedUser

---sort UserFile by FileType---
declare @OwnerId int = 1
declare @FileType int = 3

Select 
	ft.Icon,
	uf.UserFileName,
	a.UserName as OwnerName,
	uf.CreatedAt
from UserFile uf
join FileType ft on uf.FileTypeId = ft.FileTypeId
join Account a on uf.OwnerId = a.UserId
where uf.FileTypeId = @FileType and uf.OwnerId = @OwnerId

---Sort by Action recent---