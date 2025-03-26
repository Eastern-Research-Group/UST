create view ia_release.v_corrective_action_strategy as
select distinct "LUSTID", corrective_action_strategy_id, corrective_action_strategy_start_date
from
(select "LUSTID",
		"CorrectiveActionStrategy1" as corrective_action_strategy_id,
		"CorrectiveActionStrategy1StartDate" as corrective_action_strategy_start_date
from ia_release."Template"  
union all
select 	"LUSTID",
		"CorrectiveActionStrategy2" as corrective_action_strategy_id,
		"CorrectiveActionStrategy2StartDate" as corrective_action_strategy_start_date
from ia_release."Template") x
where corrective_action_strategy_id is not null;