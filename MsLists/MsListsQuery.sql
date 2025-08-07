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


--- Detail of template ---
declare @templateId int = 1
select 
	lt.Icon,
	lt.Title,
	lt.HeaderImage,
	lt.Sumary,
	lt.Feature
from ListTemplate lt
where lt.Id = @templateId



--- sample data for template ---
declare  @listTemplateId int = 5
select 
	tcl.ColumnName,
	tr.DisplayOrder,
	tc.CellValue
from TemplateColumn tcl
cross join TemplateSampleRow tr
left join TemplateSampleCell tc on tc.TemplateColumnId = tcl.Id and tc.TemplateSampleRowId = tr.Id
where tcl.ListTemplateId = @listTemplateId

--- Get data of list ---
SELECT *
FROM (
    SELECT 
        ld.ColumnName,
        lr.DisplayOrder,
        lv.CellValue
    FROM ListDynamicColumn ld
    CROSS JOIN ListRow lr
    LEFT JOIN ListCellValue lv 
        ON lv.ListColumnId = ld.Id 
       AND lv.ListRowId = lr.Id
    WHERE ld.ListId = 5 
      AND lr.ListId = 5
) AS SourceTable
PIVOT (
    MAX(CellValue) 
    FOR ColumnName IN (
        Created_By,
		ID,
		col_2_TEXT,
		Attachment,
		Title,
		Modified_By,
		col_1_INT,
		col_3_NUMBER
    )
) AS PivotTable
order by DisplayOrder



--- stage
select 1
from stages ts
	boards
	workspaces
	users
	cards
order by ts.Position
where ts.StageStatus = 'active'

	