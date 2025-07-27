USE GoogleDrive
GO



 -- Home screen
 -- select User information
 select 
	a.UserName as UserName,
	a.Email as Email
 from Account a
 where a.UserId =1 

-- select User Setting
select 
	a.UserName as UserName,
	s.SettingKey,
	s.SettingValue
from SettingUser su
join Account a on su.UserId = a.UserId
join AppSetting s on su.SettingId = s.SettingId
where a.UserId =1

-- select login user file
Declare @LoginUser int = 1 
select 
	a.UserName ,
	uf.UserFileName
from UserFile uf 
join Account a on uf.OwnerId = a.UserId
where a.UserId =@LoginUser



-- select login user folder
select 
	a.UserName ,
	fo.FolderName
from Folder fo
join Account a on fo.OwnerId = a.UserId
where a.UserId =1

-- select shared file with login user
select 
	a.UserName,
	f.UserFileName
from SharedUser su
join Account a on su.UserId = a.UserId
join Share s on su.ShareId = s.ShareId
join UserFile f on s.ObjectTypeId = 2 and s.ObjectId = f.FileId
where su.UserId = 102


select * from Share
select * from Shareduser where shareId =2

-- select shared folder with login user
select 
	a.UserName,
	fo.FolderName
from SharedUser su
join Account a on su.UserId = a.UserId
join Share s on su.ShareId = s.ShareId
join [Folder] fo on s.ObjectTypeId =1 and s.ObjectId = fo.FolderId
where su.UserId = 101

select * from share where ObjectTypeId =1
select * from SharedUser where ShareId = 1
--Recomment file/folder
select top 10
	a.UserName,
	f.UserFileName,
	ar.ActionLog,
	ar.ActionDateTime
from ActionRecent ar 
join Account a on ar.UserId = a.UserId
join UserFile f on ar.ObjectTypeId = 2 and ar.ObjectId = f.FileId
where ar.UserId = 2
order by ar.ActionDateTime DESC

select * from ActionRecent

--Recomment folder
select top 10
	a.UserName,
	fo.FolderName,
	ar.ActionLog,
	ar.ActionDateTime
from ActionRecent ar
join Account a on ar.UserId = a.UserId
join Folder fo on ar.ObjectTypeId = 1 and ar.ObjectId = fo.FolderId
where ar.UserId = 3  
order by ar.ActionDateTime DESC

select * from Recent
-- trash screen
--select file have been deleted
 SELECT 
    t.TrashId,
    ot.ObjectTypeName,
    f.UserFileName,
    t.RemovedDatetime,
    t.IsPermanent
FROM Trash t
JOIN ObjectType ot ON t.ObjectTypeId = ot.ObjectTypeId
JOIN UserFile f ON t.ObjectTypeId = 2 AND t.ObjectId = f.FileId
WHERE t.UserId = 704;

select * from Trash
--select folder have been deleted
 SELECT 
    t.TrashId,
    ot.ObjectTypeName,
    fo.FolderName,
    t.RemovedDatetime,
    t.IsPermanent
FROM Trash t
JOIN ObjectType ot ON t.ObjectTypeId = ot.ObjectTypeId
JOIN Folder fo ON t.ObjectTypeId = 1 AND t.ObjectId = fo.FolderId
WHERE t.UserId = 1;

-- Stared screen
-- Select file
select 
	f.UserFileName,
	a.USerName as FileOwnerName,
	a.UserId as UserId,
	ft.FileTypeName
from FavoriteObject fa
left join UserFile f on fa.ObjectTypeId = 2 and fa.ObjectId = f.FileId
left join Account a on f.OwnerId = a.UserId 
join FileType ft on f.FileTypeId = ft.FileTypeId
where fa.OwnerId = 794

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
where up.UserId = 100

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
where su.UserId = 101


select * from SharedUser su where su.SharedUserId = 500
select * from share s where s.ShareId = 1
select * from UserFile f where f.FileId = 298
select * from Account where UserId = 101

--select top 5 largest file 
select top 5
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
where a.UserId = 100

-- select file share by user
select 
	a.UserName,
	f.UserFileName
from Share s
join Account a on s.Sharer = a.UserId
join ObjectType ot on s.ObjectTypeId = ot.ObjectTypeId
left join UserFile f on s.ObjectTypeId = 2 and s.ObjectId = f.FileId
where s.Sharer = 100

-- select folder share by user
select 
	a.UserName,
	fo.FolderName
from Share s
join Account a on s.Sharer = a.UserId
join ObjectType ot on s.ObjectTypeId = ot.ObjectTypeId
left join [Folder] fo on s.ObjectTypeId =1 and s.ObjectId = fo.FolderId
where s.Sharer = 1

select count(*)
from Share
group by Share.Sharer

select *
from Share
where ObjectId = 654

-- select user was shared object with objectId = 654
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
where s.ObjectId = 5


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
select 
	fo.FolderPath,
	c.ColorName,
	a.UserName
from [Folder] fo
join Account a on fo.OwnerId = a.UserId
join Color c on fo.ColorId = c.ColorId
where fo.OwnerId = 20

