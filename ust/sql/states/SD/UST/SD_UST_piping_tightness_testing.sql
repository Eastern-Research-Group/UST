-- Split piping tightness testing by SD piping style (control ID 9).
-- One row per source-value pair prevents multiplying tank/compartment rows.
-- Retain the Tightness Testing token for the annual-test generator recipe.
begin;
set local lock_timeout = '5s';

create or replace view sd_ust.v_piping_tightness_testing as
select distinct
    "TankPipingType",
    "TankPipingReleaseDetection",
    case when trim("TankPipingReleaseDetection") = 'Tightness Testing'
              and trim("TankPipingType") = 'Pressure'
         then 'Tightness Testing'::text end as annual_tightness_testing,
    -- These three source values map to Suction in SD's piping-style crosswalk.
    case when trim("TankPipingReleaseDetection") = 'Tightness Testing'
              and trim("TankPipingType") in ('Safe Suction', 'Suction', 'Suction - Valve')
         then 'Tightness Testing'::text end as three_year_tightness_testing
from sd_ust.tanks;

insert into public.ust_element_mapping (
    ust_control_id, epa_table_name, epa_column_name,
    organization_table_name, organization_column_name,
    organization_join_table, organization_join_column, organization_join_fk,
    organization_join_column2, organization_join_fk2,
    query_logic, programmer_comments
)
values
    (9, 'ust_piping', 'piping_line_test_annual',
     'v_piping_tightness_testing', 'annual_tightness_testing',
     'tanks', 'TankPipingType', 'TankPipingType',
     'TankPipingReleaseDetection', 'TankPipingReleaseDetection',
     'when ''Tightness Testing'' then ''Yes'' else null end',
     'Tightness Testing with Pressure piping only; style and detection are combined in v_piping_tightness_testing.'),
    (9, 'ust_piping', 'piping_line_test3yr',
     'v_piping_tightness_testing', 'three_year_tightness_testing',
     'tanks', 'TankPipingType', 'TankPipingType',
     'TankPipingReleaseDetection', 'TankPipingReleaseDetection',
     'when ''Tightness Testing'' then ''Yes'' else null end',
     'Tightness Testing with Suction piping: Safe Suction, Suction, or Suction - Valve.')
on conflict (ust_control_id, epa_table_name, epa_column_name) do update
set organization_table_name = excluded.organization_table_name,
    organization_column_name = excluded.organization_column_name,
    organization_join_table = excluded.organization_join_table,
    organization_join_column = excluded.organization_join_column,
    organization_join_fk = excluded.organization_join_fk,
    organization_join_column2 = excluded.organization_join_column2,
    organization_join_fk2 = excluded.organization_join_fk2,
    organization_join_column3 = null,
    organization_join_fk3 = null,
    deagg_table_name = null,
    deagg_column_name = null,
    query_logic = excluded.query_logic,
    programmer_comments = excluded.programmer_comments;

-- Review the style split; all other combinations yield NULL for both fields.
select * from sd_ust.v_piping_tightness_testing
where "TankPipingReleaseDetection" = 'Tightness Testing'
order by "TankPipingType";

commit;

-- Next: ust generate-views --type ust --control-id 9 --table-name ust_piping
-- Apply the generated piping view, then run QA.
