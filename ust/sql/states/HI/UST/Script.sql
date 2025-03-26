select distinct epa_table_name, sort_order
from v_ust_element_mapping a join ust_element_table_sort_order b 
     on replace(a.epa_table_name,'v_','') = b.table_name
where ust_control_id = 37
order by sort_order;

select distinct epa_column_name, organization_table_name, organization_column_name, sort_order
from v_ust_element_mapping a join ust_elements_tables b on a.epa_table_name = b.table_name 
     join ust_elements c on b.element_id = c.element_id and a.epa_column_name = c.database_column_name 
where ust_control_id = 37 and epa_table_name = 'ust_facility' 
order by sort_order;

select ust_element_mapping_id, epa_column_name, organization_table_name, organization_column_name, organization_join_table, organization_join_column, organization_join_fk, query_logic
from ust_element_mapping
where ust_control_id = 37 and epa_table_name = 'ust_tank'
order by ust_element_mapping_id;

update ust_element_mapping
set epa_column_name = 'facility_type1'
where ust_element_mapping_id = 3108;

insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3134, null, 'Unknown', 'Mapped by ERG');

select distinct facility_id, tank_id 
 from 
 (select ts.facility_id, tank_id 
 from hi_ust.v_ust_tank_substance ts join public.substances s on ts.substance_id = s.substance_id 
 join (select distinct facility_id from 
 (select facility_id, facility_type1 as facility_type_id from hi_ust.v_ust_facility ) x 
 where facility_type_id <> 2) f on ts.facility_id = f.facility_id
 where s.substance like 'Heating%'
 union all 
 select x.facility_id, tank_id 
 from (select facility_id, tank_id, sum(compartment_capacity_gallons) as tank_capacity_gallons 
 from hi_ust.v_ust_compartment group by facility_id, tank_id) x 
 join (select distinct facility_id from 
 (select facility_id, facility_type1 as facility_type_id from hi_ust.v_ust_facility ) x 
 where facility_type_id in (1,12)) f on x.facility_id = f.facility_id 
 where tank_capacity_gallons <1100) a
 order by 1, 2;

select distinct facility_id, tank_id 
 from 
 (select ts.facility_id, tank_id 
 from hi_ust.v_ust_tank_substance ts join public.substances s on ts.substance_id = s.substance_id 
 join (select distinct facility_id from 
 (select facility_id, facility_type1 as facility_type_id from hi_ust.v_ust_facility ) x 
 where facility_type_id <> 2) f on ts.facility_id = f.facility_id
 where s.substance like 'Heating%'
 union all 
 select x.facility_id, tank_id 
 from (select facility_id, tank_id, sum(compartment_capacity_gallons) as tank_capacity_gallons 
 from hi_ust.v_ust_compartment group by facility_id, tank_id) x 
 join (select distinct facility_id from 
 (select facility_id, facility_type1 as facility_type_id from hi_ust.v_ust_facility ) x 
 where facility_type_id in (1,12)) f on x.facility_id = f.facility_id 
 where tank_capacity_gallons <1100) a
 order by 1, 2;

select * from hi_ust.v_ust_facility f
where f.facility_address1 = 'HONOLULU INTERNATIONAL AIRPORT
c/o Airport Group International
Honolulu International Airport
200 Rodgers Blvd';
'