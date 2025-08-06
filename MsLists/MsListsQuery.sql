----Account---
Declare @accountId int = 1
select 
	a.FirstName,
	a.LastName,
	a.Email,
	a.Avatar
from Account a
where a.Id = @accountId

---List types---
select 
	lt.Id,
	lt.Icon,
	lt.Title,
	lt.ListTypeDescription
from ListType lt
order by lt.Title

---Template---
select	
	lt.HeaderImage,
	lt.TemplateDescription,
	lt.Title,
	tp.ProviderName
from ListTemplate lt
join TemplateProvider tp on lt.ProviderId = tp.Id
order by lt.Title
