USE GoogleDrive
GO


select u.name, bu.BannedUserId
 from dbo.[User] u
 join BannedUser bu on bu.BannedUserId = u.UserId
 where bu.UserId = 523


 SELECT 
    t.TrashId,
    ot.Name AS ObjectType,
    f.Name AS FileName,
    fo.Name AS FolderName,
    t.RemovedDatetime,
    t.IsPermanent
FROM Trash t
JOIN ObjectType ot ON t.ObjectTypeId = ot.ObjectTypeId
LEFT JOIN [File] f ON t.ObjectTypeId = 2 AND t.ObjectId = f.FileId
LEFT JOIN Folder fo ON t.ObjectTypeId = 1 AND t.ObjectId = fo.FolderId
WHERE t.UserId = 500;




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


select top 5
	f.Name as FileName,
	u.Name as Owner,
	f.Size as FileSize
from [File] f
join [User] u on f.OwnerId = u.UserId
order by f.Size DESC

SELECT 
    BU.Id AS BanId,
    Banned.Name AS BannedUserName,
    Banner.Name AS BannedByUserName,
    BU.BannedAt
FROM BannedUser BU
JOIN [User] Banned ON BU.UserId = Banned.UserId
JOIN [User] Banner ON BU.BannedUserId = Banner.UserId
ORDER BY BU.BannedAt DESC;




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
where u.UserId = @userId

declare @userId int = 100
select 
	u.Name as UserName,
	f.Name as FileName,
	fo.Name as FolderName
from Share s
join [User] u on s.Sharer = u.UserId
join ObjectType ot on s.ObjectTypeId = ot.ObjectTypeId
left join [File] f on s.ObjectTypeId = 2 and s.ObjectId = f.FileId
left join [Folder] fo on s.ObjectTypeId =1 and s.ObjectId = fo.FolderId
where s.Sharer = @userId

select count(*)
from Share
group by Share.Sharer

select *
from Share
where ObjectId = 654


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
from [File] f
where f.FileId = 654

select *
from [Folder] f
where f.FolderId = 654