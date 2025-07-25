USE GoogleDrive
GO


 -- Home screen
 -- select User information
 select 
	u.Name as UserName,
	u.Email as Email
 from [User] u
 where u.UserId =1 

-- select User Setting
select 
	u.Name as UserName,
	s.SettingKey,
	s.SettingValue
from SettingUser su
join [User] u on su.UserId = u.UserId
join Setting s on su.SettingId = s.SettingId
where u.UserId =1

-- select login user file
select 
	u.Name as UserName,
	f.Name as FileName
from [File] f 
join [User] u on f.OwnerId = u.UserId
where u.UserId =1

-- select login user folder
select 
	u.Name as UserName,
	fo.Name as FolderName
from [Folder] fo
join [User] u on fo.OwnerId = u.UserId
where u.UserId =1

-- select shared file with login user
select 
	u.Name as UserName,
	f.Name as FileName
from SharedUser su
join [User] u on su.UserId = u.UserId
join Share s on su.ShareId = s.ShareId
join [File] f on s.ObjectTypeId = 2 and s.ObjectId = f.FileId
where su.UserId = 7

select * from Share
select * from Shareduser where shareId =3

-- select shared folder with login user
select 
	u.Name as UserName,
	fo.Name as FolderName
from SharedUser su
join [User] u on su.UserId = u.UserId
join Share s on su.ShareId = s.ShareId
join [Folder] fo on s.ObjectTypeId =1 and s.ObjectId = fo.FolderId
where su.UserId = 208

select * from share where ObjectTypeId =1
select * from SharedUser where ShareId = 2
--Recomment file/folder
select top 10
	u.Name as UserName,
	f.Name as FileName,
	r.Log as Log,
	r.DateTime as DateTime
from Recent r
join [User] u on r.UserId = u.UserId
join [File] f on r.ObjectTypeId = 2 and r.ObjectId = f.FileId
where r.UserId = 319
order by r.DateTime DESC

select * from Recent

--Recomment folder
select top 10
	u.Name as UserName,
	fo.Name as FolderName,
	r.Log as Log,
	r.DateTime as DateTime
from Recent r
join [User] u on r.UserId = u.UserId
join [Folder] fo on r.ObjectTypeId = 1 and r.ObjectId = fo.FolderId
where r.UserId = 231  
order by r.DateTime DESC

select * from Recent
-- trash screen
--select file have been deleted
 SELECT 
    t.TrashId,
    ot.Name AS ObjectType,
    f.Name AS FileName,
    t.RemovedDatetime,
    t.IsPermanent
FROM Trash t
JOIN ObjectType ot ON t.ObjectTypeId = ot.ObjectTypeId
JOIN [File] f ON t.ObjectTypeId = 2 AND t.ObjectId = f.FileId
WHERE t.UserId = 500;

--select folder have been deleted
 SELECT 
    t.TrashId,
    ot.Name AS ObjectType,
    fo.Name AS FolderName,
    t.RemovedDatetime,
    t.IsPermanent
FROM Trash t
JOIN ObjectType ot ON t.ObjectTypeId = ot.ObjectTypeId
JOIN Folder fo ON t.ObjectTypeId = 1 AND t.ObjectId = fo.FolderId
WHERE t.UserId = 500;

-- Stared screen
-- Select file
select 
	f.Name as FileName,
	u1.Name as FileOwnerName,
	u1.UserId as UserId,
	ft.Name as FileTypeName
from FavoriteObject fa
left join [file] f on fa.ObjectTypeId = 2 and fa.ObjectId = f.FileId
left join [User] u1 on f.OwnerId = u1.UserId 
join FileType ft on f.FileTypeId = ft.FileTypeId
where fa.OwnerId =100

select * from FavoriteObject where OwnerId = 100
select * from [File] f where f.FileId = 151

--product Screen
-- select all of product
select * from [Product]

-- select Product bought by user
select 
	pro.Name as ProductName,
	u.Name as UserName,
	case
		when po.IsPercent = 1 then pro.Cost * (po.Discount/100)
		else pro.Cost - po.Discount
	end as TotalCost
from UserProduct up
join [User] u on up.UserId = u.UserId
join Promotion po on up.PromotionId = po.PromotionId
join [Product] pro on up.ProductId = pro.ProductId
where up.UserId = 100

select * from Promotion
select * from [Product]
select * from UserProduct up where up.UserId = 100

-- select Top 10 Payers 
select top 10
	pro.Name as ProductName,
	u.Name as UserName,
	case
		when po.IsPercent = 1 then pro.Cost * (po.Discount/100)
		else pro.Cost - po.Discount
	end as TotalCost
from UserProduct up
join [User] u on up.UserId = u.UserId
join [Product] pro on up.ProductId = pro.ProductId
join Promotion po on up.PromotionId = po.PromotionId
order by TotalCost DESC

-- select file/folder shared for user with userid = 500
select 
	u.Name as UserName,
	p.Name as Permission,
	f.Name as FileName,
	fo.Name as FolderName
from SharedUser su
join [User] u on su.SharedUserId = u.UserId
join Share s on su.ShareId = s.ShareId
join Permission p on su.PermissionId = p.PermissionId
LEFT join Folder fo on s.ObjectTypeId = 1 and fo.FolderId = s.ObjectId
LEFT join [File] f on s.ObjectTypeId = 2 and f.FileId = s.ObjectId
where su.SharedUserId = 500


select * from SharedUser su where su.SharedUserId = 500
select * from share s where s.ShareId = 547
select * from [File] f where f.FileId = 298

--select top 5 largest file 
select top 5
	f.Name as FileName,
	u.Name as Owner,
	f.Size as FileSize
from [File] f
join [User] u on f.OwnerId = u.UserId
order by f.Size DESC


--select banned user
SELECT 
    BU.Id AS BanId,
    Banned.Name AS BannedUserName,
    Banner.Name AS BannedByUserName,
    BU.BannedAt
FROM BannedUser BU
JOIN [User] Banned ON BU.UserId = Banned.UserId
JOIN [User] Banner ON BU.BannedUserId = Banner.UserId
ORDER BY BU.BannedAt DESC;

--select product bought by user 
select 
	p.Name as ProductName,
	u.Name as UserName,
	up.PayingDatetime,
	up.EndDatetime,
	pr.Name as PromotionName
from UserProduct up
join [Product] p on up.ProductId = p.ProductId
join [User] u on up.UserId = u.UserId
join Promotion pr on up.PromotionId = pr.PromotionId
where u.UserId = 100

-- select file/folder share by user
select 
	u.Name as UserName,
	f.Name as FileName,
	fo.Name as FolderName
from Share s
join [User] u on s.Sharer = u.UserId
join ObjectType ot on s.ObjectTypeId = ot.ObjectTypeId
left join [File] f on s.ObjectTypeId = 2 and s.ObjectId = f.FileId
left join [Folder] fo on s.ObjectTypeId =1 and s.ObjectId = fo.FolderId
where s.Sharer = 100

select count(*)
from Share
group by Share.Sharer

select *
from Share
where ObjectId = 654

-- select user was shared object with objectId = 654
select 
	u.Name as UserName,
	f.Name as FileName,
	fo.Name as FolderName,
	p.Name as PermissionName
from Share s
	join SharedUser su on s.ShareId = su.ShareId
	join [User] u on su.UserId = u.UserId
	join Permission p on su.PermissionId = p.PermissionId
	left join [File] f on s.ObjectTypeId =2 and s.ObjectId = f.FileId
	left join [Folder] fo on s.ObjectTypeId =1 and s.ObjectId = fo.FolderId
where s.ObjectId = 654


select *
from [File] fm
where f.FileId = 654

select *
from [Folder] f
where f.FolderId = 654

--User Management: Retrieve the names and email addresses of all users who have used more than 5% of their storage capacity.
select 
	u.Name as UserName,
	u.Email as UserEmail
from [User] u
where ((CAST(u.UsedCapacity AS FLOAT) / u.Capacity) * 100) > 5

select * from [User]


--Folder Structure: List all folders owned by a specific user (e.g., UserId = 1), including their full path and the name of the color associated with each folder.
select 
	fo.Path,
	c.ColorName,
	u.Name as UserName
from [Folder] fo
join [User] u on fo.OwnerId = u.UserId
join Color c on fo.ColorId = c.ColorId
where fo.OwnerId = 20

