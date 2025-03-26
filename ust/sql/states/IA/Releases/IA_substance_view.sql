create view ia_release.v_substance_released as
select distinct "LUSTID", substance_released, quantity_released, unit
from
(select "LUSTID",
		"SubstanceReleased1" as substance_released,
		"QuantityReleased1" as quantity_released,
		"Unit1" as unit
from ia_release."Template"  
union all
select 	"LUSTID",
		"SubstanceReleased2" as substance_released,
		"QuantityReleased2" as quantity_released,
		"Unit2" as unit
from ia_release."Template"
union all
select 	"LUSTID",
		"SubstanceReleased3" as substance_released,
		"AmountReleased3" as quantity_released,
		"Unit3" as unit
from ia_release."Template"
union all
select 	"LUSTID",
		"SubstanceReleased4" as substance_released,
		"AmountReleased4" as quantity_released,
		"Unit4" as unit
from ia_release."Template"
union all
select 	"LUSTID",
		"SubstanceReleased5" as substance_released,
		"AmountReleased5" as quantity_released,
		"Unit5" as unit
from ia_release."Template") x
where substance_released is not null;