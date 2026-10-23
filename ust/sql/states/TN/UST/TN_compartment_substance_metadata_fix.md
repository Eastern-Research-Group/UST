# TN compartment-substance generation fix

`public.ust_compartment_substance` stores `ust_tank_substance_id`, not
`substance_id`. The input view must still expose `substance_id` so the loader
can resolve the tank-substance foreign key. The population metadata previously
dropped this mapping because it required the column to exist in the destination
table.

The repository DDL now resolves this one logical input column's datatype from
`public.substances.substance_id`. Other mappings retain their existing datatype
lookup. No destination-table or Python loader changes are needed.

## Apply and verify

1. Execute the complete updated
   [v_ust_table_population.sql](../../../ddl/public/view/v_ust_table_population.sql)
   in the target database. Editing the repository file alone does not update the
   database. `v_ust_table_population_sql` reads this view and needs no replacement.
2. Verify TN's mapped substance column is now available to generation (TN control
   ID is 35 in the repository scripts):

```sql
select epa_column_name, column_sort_order, data_type, selected_column
from public.v_ust_table_population_sql
where ust_control_id = 35
  and epa_table_name = 'ust_compartment_substance'
order by column_sort_order;
```

Expect `substance_id` with a non-null sort order, integer datatype, and
`substance_id as substance_id,` as its selected column. Its sort order must not
collide with another column.

3. Generate the corrected TN view SQL without overwriting the state's SQL file:

```powershell
ust generate-views --type ust --control-id 35 --table-name ust_compartment_substance --print-console --no-write-sql --yes
```

4. Execute the generated view DDL in the target database. Verify it exposes
   `facility_id`, `tank_id`, `compartment_id`, and `substance_id`:

```sql
select column_name, data_type
from information_schema.columns
where table_schema = 'tn_ust'
  and table_name = 'v_ust_compartment_substance'
order by ordinal_position;
```

5. Confirm both substance views exist and are registered for QA/population:

```sql
select t.view_name, t.sort_order,
       to_regclass('tn_ust.' || t.view_name) as existing_relation
from public.ust_template_data_tables t
where t.view_name in ('v_ust_tank_substance', 'v_ust_compartment_substance')
order by t.sort_order;
```

Both rows must be present with non-null relations. Tank substances must load
before compartment substances. This metadata fix does not recreate a missing
`v_ust_tank_substance`; generate and execute that view separately if needed.

6. Rerun `ust qa --type ust --control-id 35 --yes`. After resolving QA findings,
   use the normal population/export workflow. The existing loader matches
   facility within control ID, tank within facility, compartment within tank,
   and substance within that same tank to populate the two foreign keys.

This fix addresses the missing input column. It does not change TN regulatory
exclusions or resolve the separate duplicate-tank findings.
